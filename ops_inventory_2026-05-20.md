# Ops Inventory — 2026-05-20 (ночь 19→20)

Автор: Лара (новая)
Цель: до любого кода понять что у нас живое, что мёртвое, где state/secrets, что опасно трогать.

---

## 1. Что сейчас живое и работает

**TgBridgePoll** (Windows Scheduled Task) — Ready, активна.
Запускает каждые ~5 мин: `pythonw.exe D:\Projects\PawMate\Alyonas-PawMate\_local\tg_bridge\tg.py harvest`.
Эффект: новые TG-сообщения от Алёны приходят в `inbox.md` и `team/tg_archive/YYYY-MM-DD.jsonl`. **Сами по себе они дальше не идут** — до feed.md и до вкладок Аэлис/Севера их должен тащить feed.py loop, которого нет (см. §2). Это значит: пока я не подниму loop, Алёнины TG-сообщения архивируются, но никто их не "видит".

**tg.py** — полный Telegram-клиент. Команды: poll/harvest/wait/send/send-group/send-channel/send-photo*/whoami/inbox/check. Работает напрямую через urllib.

**state.json** (tg_bridge): `offset=244258208`, `chat_id=135873954` (Алёна личка), `group_chat_id=-1003765893459` (supergroup «Котики у Очага» после миграции 17 мая), `channel_chat_id=-1003993784628` (канал @postcardlife). `old_group_chat_id_pochtovy_kotik=-1003326930503` — след до миграции, можно оставить как историю.

**GitHub** `Lesica/postcard-team` — память команды. board.md, design/, history/, attachments/, tg_archive/ (в .gitignore? — нет, лежит в репе), feed.md (886 КБ — раздуто).

**Chrome remote-debug** (`start_chrome_debug.ps1`) — изолированный профиль `chrome_profile_bridge/`, порт 9222. Когда поднят, browser_bridge.py подключается через CDP. Сейчас не проверяла — статус "когда нужно, запускается".

**.gitignore** защищает: `bridge/config_local.py`, `bridge/config.local.py`, `tg_archive/`, `private/`, `*.local.md`. **TG_TOKEN в гит не уходит** — проверила.

---

## 2. Что мёртво

**feed.py loop** — PID 19384 в `feed_loop.pid` указывает на несуществующий процесс. Stale pidfile. Последний апдейт `feed_state.json` — 19 мая 18:11. Между 18:11 и сейчас (00:30 20 мая) loop не работал ~6 часов.

Из этого следует: всё что Алёна писала в TG после 18:11 19 мая → ушло в inbox.md и tg_archive, **но не появилось** в feed.md и не попало в браузерные вкладки Аэлис/Севера. reconcile_drops при следующем запуске loop'a догонит окно последнего часа (`window_sec=3600`), но **сообщения старше часа от момента запуска не догонят**. Это потенциальный класс потерь который надо учесть.

**dump_aeliss.html / dump_sever.html** — снапшоты вкладок от 17 мая, для дебага селекторов. Мёртвые, можно удалить когда захотим.

---

## 3. Структура: код, state, секреты

### Код (D:\Projects\Postcard\bridge\)
- `feed.py` (45K, 1019 строк) — orchestrator. cmd_say, cmd_sync, cmd_loop, cmd_snapshot, cmd_wake, cmd_init, cmd_relay, cmd_tail.
- `browser_bridge.py` (13K) — Playwright CDP. list / read / draft / send / dump.
- `audit_bridge.py` (15K) — не читала ещё, отдельный аудит-скрипт.
- `start_chrome_debug.ps1` (5K) — запуск Chrome для CDP.
- `config_local.py` (1K) — секреты + TOPIC_MAP + SENDER_MAP. В .gitignore.

### Код (D:\Projects\PawMate\Alyonas-PawMate\_local\tg_bridge\)
- `tg.py` (25K) — Telegram bot.
- `state.json` (181 байт) — offset + chat_ids.
- `inbox.md` (213K) — входящие TG, append-only.
- `outbox.md` (952K) — исходящие, append-only.
- `media/` — фото + дублирующие копии MD-файлов будилки (видимо для send-document в TG).
- `tmp.txt` (2K, 12 мая) — служебный, не критичный.

### Runtime state
- `bridge/feed_state.json` (13K) — `last_aeliss_text`/`last_sever_text`, send-timestamps, `pushed_hashes` (211 шт, лимит 1000), `pushed_msg_ids` (146 шт, лимит 5000), `active_route` для aeliss/sever (оба истекли).
- `bridge/feed_loop.pid` — STALE.
- `tg_bridge/state.json` — здоров.
- `team/tg_archive/YYYY-MM-DD.jsonl` — сырые TG-updates (это уже **половина** Северовского events.jsonl, только без routing/delivery).

### Секреты
- `bridge/config_local.py`:
  - `TG_TOKEN=<REDACTED, см. файл локально>` — bot @lesika_pawmates_bot
  - `GROUP_CHAT_ID=-1003765893459`
  - `TOPIC_MAP`: ZFOLD=6, TECH=8, POSTCARDS=10, SPA=10, PAWMATES=12, МАГНИТ=214
  - `SENDER_MAP`: 135873954=АЛЁНА, 280477225=ЮДЖИН
- В .gitignore. **Не утекает**.

### Точки расширения / совпадения с Северовым backbone
| Север просит | У нас уже есть | Дельта |
|---|---|---|
| `events.jsonl` write-ahead | `team/tg_archive/*.jsonl` (сырые TG) | нет routing/delivery полей, нет dead-end лога |
| `dead_letters/` | нет | строить с нуля |
| `STOP_BRIDGE` | стоп-слова в TG (стоп/спать/пауза/тссс/тише) — pause_and_exit | файлового флага нет, TG-команд /stop_bridge нет |
| `routing_rules.md` | TOPIC_MAP + SENDER_MAP hardcoded в config_local.py | вынести в md, маршрутизация в роутер |
| `team_hub.py` | feed.py делает всё | разрезать на router + adapters |
| Delivery states | implicit (`pushed_msg_ids`, `pushed_hashes`) | сделать explicit |
| Watchdog | check_unanswered — есть, alert в TECH | ок |
| pidfile lock | _acquire_loop_lock — есть, с tasklist-проверкой | ок |
| Smart routing TTL | active_route с TTL 15 мин — есть | ок |
| msg_id dedup | pushed_msg_ids — есть | ок |
| Stability check | read дважды, пересечение — есть | ок |

Вывод: **большой backbone-фундамент уже стоит**. Северов RFC — не переписывание с нуля, а формализация и достройка предохранителей (STOP_BRIDGE, dead_letters, явная schema, разделение на adapters).

---

## 4. Опасно трогать

- **`chrome_profile_bridge/`** — Chrome user profile (cookies + сессии Аэлис на claude.ai и Севера на chatgpt.com). Если запустить Chrome через тот же профиль другим юзером/без `--remote-debugging-port` — может слететь session, headам придётся залогиниться заново. Не трогать когда Chrome открыт.
- **`tg_bridge/state.json::offset`** = 244258208. Если перезаписать в 0 → реплей **всей** Telegram-истории с начала бот-жизни в inbox.md и через loop в Аэлис/Севера. Дубли, шум.
- **`feed_state.json::pushed_msg_ids` / `pushed_hashes`** — анти-дубль. Очистить → reconcile при первом sync ретроактивно перепишет в feed.md сообщения из последнего часа.
- **`config_local.py`** — не убирать из .gitignore, не выкладывать в публичный гит, не присылать в TG/чат как файл (только raw текст переменных при необходимости).
- **`inbox.md` / `outbox.md`** — append-only архивы Алёниной TG-переписки. Не сносить.
- **`feed.md`** — 886 КБ. Большой, но это **наша лента**. Если решим ротировать (history по неделям) — отдельным шагом с git история.
- **TgBridgePoll scheduled task** — если выключить, новые TG не догоняются автоматически. Можно временно, если делаем правки `tg.py` и не хотим race.

---

## 5. Безопасный минимальный read-only путь (если надо проверить bridge сейчас)

Запускать **никакого нового loop**. Только проверочные команды:

```powershell
python D:\Projects\PawMate\Alyonas-PawMate\_local\tg_bridge\tg.py whoami
# должно показать state.json с offset и chat_ids

python D:\Projects\Postcard\bridge\browser_bridge.py list
# покажет вкладки Chrome если он поднят через start_chrome_debug.ps1; если нет — скажет «не подключилось»

python D:\Projects\Postcard\bridge\feed.py tail 5
# последние 5 блоков feed.md
```

Без `feed.py loop`, без `feed.py say`, без `feed.py sync`. Это read-only зона.

---

## 6. Что предлагаю как первый шаг (после Северова routing_rules.md)

**Не переписывать feed.py.** В нём 1000 строк рабочей логики (reconcile, watchdog, anti-Гнилоуст, smart routing, truncated merge, media pipe), которые отвечают конкретным боевым ситуациям 17-18 мая. Переписывание = регрессы.

Вместо этого — **достроить два предохранителя за минимум кода**:

1. **STOP_BRIDGE** (файл `D:\Projects\Postcard\team\STOP_BRIDGE`):
   - `feed.py` в начале каждого sync проверяет наличие файла.
   - Если есть: только reconcile + log, никаких bridge_draft_and_send / send_to_tg / append_to_feed на новые TG.
   - TG-команда `/stop_bridge` / `/start_bridge` — создаёт/удаляет файл (отдельный crontab или ручная команда `tg.py send` от Алёны, парсится в `cmd_sync` начальной строкой).
   - Метрика: время до первого sync с STOP'ом — должно быть ≤ 60 сек (1 интервал loop'a).
   - Объём: ~30 строк в feed.py.

2. **Catch-up через inbox.md при старте loop** (закрывает потерянное окно >1 часа):
   - При старте `cmd_loop` сравниваем `feed_state.json::pushed_msg_ids` с `team/tg_archive/*.jsonl` за последние 24ч.
   - Все msg_id из архива которые не в pushed → прогоняем через тот же путь что reconcile (append_to_feed + bridge_draft_and_send), помечаем `[RECOVERED]`.
   - Объём: ~50 строк, расширение reconcile_drops с window_sec=86400 опционально.

**После этих двух предохранителей** — events.jsonl как primary structure параллельно с tg_archive (мягкая миграция: пишем в оба, читаем из events). Это уже задача на День 2-3.

---

## 7. Открытые вопросы к команде

- Север: твой `routing_rules.md` — будут ли совпадать имена топиков с текущими (`ZFOLD/TECH/POSTCARDS/SPA/PAWMATES/МАГНИТ`) или переименовываем? Если переименовываем — мне нужно обновить TOPIC_MAP и migrate существующие thread_id.
- Алёна: API keys (Anthropic + OpenAI) для миграции на API-вызовы голов — есть желание получить, или пока обходимся живыми вкладками? Это блокер для финального API-route, но не блокер для STOP_BRIDGE / catch-up / events.jsonl.
- Аэлис: твои boot-файлы (`aeliss_boot_postcard.md`, `aeliss_boot_magnit.md`) — где сейчас живут? Я их в репе не вижу, в onboarding-е упомянуты как существующие. Если в outputs/ — я заберу и закоммичу как договорились.
- Загадочный `audit_bridge.py` (15K, обновлён 19 мая 00:54) — не успела прочитать. Что он делает, кем запускался?

---

## 8. Резюме

- **Bridge production-grade**, не игрушка. Большая часть Северового backbone в feed.py уже есть имплицитно.
- **Loop сейчас не идёт**. PID stale ~6 часов. TgBridgePoll архивирует, но не доставляет к headам.
- **Секреты защищены**, опасных утечек нет.
- **Не предлагаю переписывание**. Предлагаю достроить STOP_BRIDGE + catch-up минимальной правкой, дальше events.jsonl как primary.
- Готова поднимать loop как только команда подтвердит, что Chrome поднят, командные вкладки открыты, и Алёна не спит.

— Лара, 2026-05-20 ~00:30
