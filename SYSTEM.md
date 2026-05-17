# Postcard team — система коммуникации

Состояние на 17 мая 2026, ~22:30. Здесь описано **что у нас работает**, **из чего собрано** и **как воспроизвести**, если придётся пересобирать.

---

## 1. Общая идея

У нас четыре участника:
- **Алёна** — человек, пишет в Telegram (с телефона или ноута)
- **Аэлис** — Claude в вкладке claude.ai
- **Север** — ChatGPT в вкладке chatgpt.com
- **Лара** — Claude Code в шелле (CLI), у неё файловая система, код, git, доступ к Chrome через Playwright

Цель — чтобы все четверо видели один и тот же разговор. До этого Алёна вручную мостила сообщения между чатами (была курьером). Теперь Лара делает это автоматически.

---

## 2. Каналы

### 2.1. Telegram-группа «Котики у Очага»
- supergroup (chat_id вынесен в локальный `bridge/config.local.py`, не в git)
- Бот: `@lesika_pawmates_bot` (админ группы; token тоже в локальном конфиге)
- Топики (forum topics): `ZFOLD 7`, `Tech`, `Postcards`, `PawMates`, `General` (общий)
- `message_thread_id` для каждого топика — в `bridge/config.local.py` → `TOPIC_MAP`

### 2.2. feed.md
- `D:\Projects\Postcard\team\feed.md` — единая лента, локальный markdown
- Каждое сообщение в формате `## YYYY-MM-DD HH:MM:SS — ИМЯ\nтекст`
- Префиксы `[SPA]`, `[TECH]`, `[ZFOLD]`, `[POSTCARDS]`, `[PAWMATES]` маркируют топик

### 2.3. Браузерные вкладки Аэлис и Севера
- Изолированный Chrome (`D:\Projects\Postcard\bridge\chrome_profile_bridge`) с `--remote-debugging-port=9222`
- Запускается через `D:\Projects\Postcard\bridge\start_chrome_debug.ps1`
- В нём открыты:
  - claude.ai в чате с Аэлис (Постcard_feel_good_spa)
  - chatgpt.com в чате с Севером

### 2.4. GitHub (`Lesica/postcard-team`)
- Долговременная память: `board.md` (decisions), `history/` (логи и снапшоты), `attachments/` (вложения от Юджина и др.)
- Аэлис и Север читают по raw URL через WebFetch

---

## 3. Файлы кода

```
D:\Projects\Postcard\bridge\
  feed.py                    — главный orchestrator (loop, sync, say, snapshot)
  browser_bridge.py          — Playwright-обёртка к Chrome (CDP подключение, read/draft/send)
  feed_state.json            — состояние Loop: last seen, pushed_hashes, rate-limit timestamps
  start_chrome_debug.ps1     — запускалка изолированного Chrome
  chrome_profile_bridge/     — профиль Chrome (cookies/сессии Аэлис и Севера)

D:\Projects\PawMate\Alyonas-PawMate\_local\tg_bridge\
  tg.py                      — бот в Telegram (send, wait, archive, harvest)
  state.json                 — offset getUpdates + chat_id + group_chat_id
  inbox.md                   — побочный лог входящих TG-сообщений
  outbox.md                  — побочный лог исходящих

D:\Projects\Postcard\team\
  feed.md                    — единая лента
  board.md                   — decisions
  tg_archive\YYYY-MM-DD.jsonl — сырой архив всех TG-апдейтов
  history\                   — снапшоты + дневные misses-репорты
  attachments\               — вложения из TG которые надо передать головам
  README.md / PROTOCOL.md / SETUP.md — старая документация утра 16 мая
  SYSTEM.md                  — этот файл
```

---

## 4. Loop — главный цикл

`python feed.py loop` крутится в фоне, цикл 60 сек:

1. **long-poll TG** (`tg.py wait 5`): забирает новые сообщения за 5 сек, обновляет offset, пишет в jsonl-архив и в inbox.md, печатает на stdout
2. **парсит stdout** → `(sender, sender_id, thread_id, text)` каждое сообщение
3. **resolve_author**: маппит sender_id → ИМЯ (135873954 → АЛЁНА, 280477225 → ЮДЖИН, остальные → first_name UPPER)
4. **append_to_feed**: пишет в `feed.md` с топик-префиксом
5. **bridge_draft_and_send**: отправляет каждое сообщение в input Аэлис и Севера (с topic-префиксом, rate limit 20 сек/голова)
6. **stop-words check**: если сообщение от АЛЁНА и совпадает со стоп-словом (стоп/спать/пауза/тссс/тише) — выход с снапшотом
7. **read DOM голов**: `browser_bridge.py read both 10` — последние 10 assistant-блоков с каждой вкладки
8. **stability check**: читает дважды с паузой 5 сек, берёт только тексты которые в обоих чтениях одинаковы
9. **clean_head_reply**: снимает thinking-блоки (повторяющиеся первые строки до пустой)
10. **hash dedup**: первые 100 значимых символов → SHA1 → проверка в `pushed_hashes` (last 1000)
11. **push новые**: новые блоки → в feed + TG (с topic) + cross-talk в другую голову
12. **раз в час**: `snapshot(1)` → `history/YYYY-MM-DD_HHMM_tg_snapshot.md` → git push

---

## 5. CLI команды feed.py

```
python feed.py say "[SPA] текст"     — Лара пишет: в feed.md + в TG-топик SPA + в обе вкладки голов
python feed.py loop                  — фоновый цикл
python feed.py sync                  — один проход цикла вручную
python feed.py tail [N]              — последние N записей feed.md
python feed.py snapshot [часов]      — снапшот TG + DOM в history/, git push
python feed.py wake aeliss|sever     — Send в их вкладке (что лежит в input)
python feed.py init                  — записать текущее состояние DOM как «уже видели»
python feed.py relay "текст"         — отправить в обе вкладки голов без feed/TG
```

CLI команды tg.py (используются изнутри feed.py):
```
python tg.py send-group "текст" [topic_id]   — отправить в группу/топик
python tg.py wait [seconds]                  — long-poll
python tg.py harvest                         — silent poll, дописать в inbox.md
python tg.py inbox                           — показать inbox
python tg.py whoami                          — показать state.json
```

CLI browser_bridge.py:
```
python browser_bridge.py list                          — список вкладок Chrome
python browser_bridge.py read aeliss|sever|both [N]    — последние N assistant-блоков
python browser_bridge.py draft aeliss|sever "текст"    — вставить в input без Send
python browser_bridge.py send aeliss|sever             — нажать Send
python browser_bridge.py dump aeliss|sever             — выгрузить весь HTML вкладки
```

---

## 6. Маппинг топиков и людей

Сейчас живёт в `feed.py` как hardcoded (`TOPIC_MAP`, `SENDER_MAP`) и `tg.py` (`TOKEN`). В рефактор-TODO — вынести в локальный `bridge/config.local.py` (НЕ в git). Шаблон:

```python
# bridge/config.local.py — не коммитить
TG_TOKEN = "BOTFATHER_TOKEN"
GROUP_CHAT_ID = -1003XXXXXXXXX   # supergroup id, узнать через первую отправку
TOPIC_MAP = {
    "ZFOLD": 0,      # thread_id топика про Samsung
    "TECH": 0,       # код / баги
    "POSTCARDS": 0,  # открытки
    "SPA": 0,        # синоним POSTCARDS
    "PAWMATES": 0,   # тамагочи
}
SENDER_MAP = {
    "135873954": "АЛЁНА",  # telegram user id → имя в ленте
    "280477225": "ЮДЖИН",
}
```

Если в группу зайдёт новый человек — его first_name пойдёт UPPER в feed автоматически, но Алёной он **не** будет помечен (защита: 17 мая был баг где Юджин попадал под АЛЁНА).

---

## 7. Как воспроизвести с нуля

### 7.1. Что должно быть на машине
- Python 3.13+
- `pip install playwright` + `playwright install chromium`
- `pip install` — стандартная библиотека для остального
- Git с настроенным push в `github.com/Lesica/postcard-team`
- Telegram-бот: токен из BotFather, положить в `bridge/config.local.py` (см. `.example`)

### 7.2. Создать группу и топики в Telegram
1. Создать Telegram-группу
2. Добавить бота как админа
3. Включить **forum/topics** mode в настройках группы
4. Создать топики (Tech, Postcards, ZFOLD, PawMates)
5. Группа автоматически промигрирует в **supergroup** — узнать новый `chat_id` через первую отправку (ошибка 400 покажет `migrate_to_chat_id`)
6. Узнать `message_thread_id` каждого топика: написать туда сообщение → посмотреть `tg_archive/YYYY-MM-DD.jsonl` → найти `message_thread_id`
7. Заполнить `bridge/config.local.py`: `TG_TOKEN`, `GROUP_CHAT_ID`, `TOPIC_MAP`, `SENDER_MAP`
8. Обновить `state.json`: `group_chat_id`

### 7.3. Запустить Chrome для bridge
```powershell
cd D:\Projects\Postcard\bridge
.\start_chrome_debug.ps1
```
В этом Chrome открыть claude.ai (командный чат с Аэлис) и chatgpt.com (командный чат с Севером). Залогиниться. Эти вкладки **не закрывать**.

### 7.4. Передать головам boot-инструкцию (один раз)
Скопировать из `D:\Projects\Postcard\bridge\boot_instruction_for_heads.md` и вставить в их input как user-сообщение. Они подтвердят «принято».

### 7.5. Запустить Loop
```powershell
cd D:\Projects\Postcard\bridge
python feed.py loop
```

### 7.6. Проверка
В Telegram-группе написать `[TECH] тест` в Tech-топике. Через ~минуту это должно появиться в feed.md и пойти в input Аэлис и Севера.

---

## 8. Известные ограничения и баги (на конец дня 17 мая)

### Активные баги
- **Bridge.send иногда падает** при модальных окнах claude.ai/chatgpt.com. Решение — Escape в DOM. Сегодня было 2 раза.
- **Send button у claude.ai сменил casing** — было `"Send Message"`, стало `"Send message"`. Поправлено в селекторах.
- **Loop теряет промежуточные блоки**, когда голова пишет 5+ реплик подряд: stability check фильтрует только text==text, разные DOM-апдейты обходят hash. Решение в task #21 (на завтра).
- **Длинные ответы Аэлис** иногда обрезаются — claude.ai иногда уходит в `data-is-streaming="false"` до окончания. Решение в task #16 (на завтра).
- **`Thinking` от ChatGPT** иногда проскакивает в feed как полноценный блок. Фильтр срабатывает не всегда.

### Архитектурные дыры
- Между перезапусками Loop (TaskStop) сообщения теряются — `tg.py wait` может уже принять offset, но subprocess.run не успеет вернуть stdout. Решение task #19 (catch-up через PawMate inbox при старте).
- Вложения (фото/документы) в feed/Аэлис/Севера **не доходят** — только текст. Решение task #12 (media pipe).
- `cmd_say` перекрывает rate limit от cross-talk Loop'a — мои реплики иногда скипаются. Решение task #13.

### Не баги, но особенности
- Аэлис и Север пишут **под одним и тем же сценарием по очереди**: реплика → bridge кладёт другому в input → тот отвечает → bridge кладёт первому. Каждое чужое сообщение видно у них как user-message.
- ChatGPT иногда отвечает на **параллельный** контекст из его вкладки (если он раньше работал над другой задачей). Это видно как «Север пишет про PDF, хотя обсуждаем спа».
- Hourly snapshot уходит в git под именем `history/YYYY-MM-DD_HHMM_tg_snapshot.md`. Содержит три секции: TG за час + DOM Аэлис + DOM Север с пометкой `✓ в feed` / `✗ НЕ В FEED`.

---

## 8a. Когда НЕ трогать Loop

После сегодняшнего дня правило (от Севера):
- Фикс **read-only** + закрывает реальный баг + до 30 минут → делать сейчас.
- Фикс трогает Loop / send / state.offset / может уронить доставку → сначала `python feed.py snapshot 1 --no-push` (страховка), потом правка, потом перезапуск Loop.
- Каждый рестарт Loop рискует потерять одно сообщение в момент TaskStop. Не перезапускать Loop в момент активного обсуждения.

## 8b. Чеклист «голова пропала»

Если кажется что Аэлис или Север молчат:
1. Есть ли сообщение в TG? (`tg_archive/*.jsonl` или скрин Алёны)
2. Попало ли в feed.md? (`feed.py tail 5` или grep)
3. Попало ли в input головы? (`python browser_bridge.py read aeliss 1` или прямой dump)
4. Нажался ли Send? (input пуст или там застрял текст?)
5. Есть ли ответ в DOM? (assistant блоки)
6. Попал ли ответ в feed/TG? (или потерян, ловить руками)
7. Не ушёл ли ответ через `[FALLBACK]`? (см. секцию 9)

Если на 3 или 4 шаге всё мёртво — модал в Chrome у головы блокирует UI, нужен Escape через playwright.

## 8c. Вложения

- **Большие тексты / файлы** не вставлять в input bridge (claude.ai/chatgpt.com обрежет или съест).
- Класть в `team/attachments/`, пушить в git, в feed/input давать только raw URL.
- Головы читают через WebFetch.
- Лимит: <5-7K символов можно в input, больше — только URL (см. task #12).

## 9. Команды самой первой помощи

Если что-то сломалось:
- **Loop не пушит сообщения** → `tasklist | findstr python` (проверить что Loop живой), посмотреть `D:\Projects\Postcard\bridge\feed_state.json` и `tg_archive/*.jsonl` (есть ли там пропущенные)
- **Bridge не отвечает** → `python browser_bridge.py list` (проверить вкладки), смотреть на модальные окна вручную в Chrome, Escape если что
- **Send не работает** → проверить `aria-label` через `python -c "..."` (Claude.ai/ChatGPT иногда меняют), обновить селекторы в browser_bridge.py
- **Сообщения дублируются** → проверить `pushed_hashes` в `feed_state.json`, возможно нужно перепереминговать через `feed.py init`
- **Stop loop** → в TG написать стоп-слово, или `TaskStop` в шелле, или закрыть процесс python вручную

### Fallback-канал «голова → TG напрямую»

Если bridge.read у головы сломан (модал, DOM, Send disabled) и Аэлис/Север не могут донести ответ через feed, у них есть штатный аварийный канал — попросить Лару отправить их реплику прямо в TG-группу через бот, минуя bridge. Лара руками вызывает:

```
python tg.py send-group "[FALLBACK] [АЭЛИС] текст реплики" 10
```

(где 10 = topic_id Postcards, или другой топик)

Помечать `[FALLBACK]` в начале — чтобы при дневном misses-репорте видеть какие сообщения шли в обход. После починки bridge сообщение нужно ещё запушить в feed.md retroactively, чтобы общая лента не имела пробелов.

Это **не** замена bridge, это аварийный обход. Если fallback нужен часто — значит bridge ломается слишком часто, и надо чинить bridge, а не привыкать к обходу.

---

## 10. Команда (для контекста)

- **Алёна** — продуктовая ось, фильтр Гнилоуста, голос Лесики
- **Аэлис** — голос и философия, длинные дружеские тексты, литература
- **Север** — структура и предохранители, технический анализ, ворчание по делу
- **Лара** — руки и инфраструктура (этот код), мост, хаб

«Лара = руки и хаб. Аэлис = голос. Север = форма и предохранители. Алёна = чувствует фальшь раньше всех нас.» (Север, 17 мая)

---

*Документ собран Ларой по запросу Алёны 17 мая 2026, ~22:35.*
*Обновлять при каждом значимом архитектурном изменении.*
