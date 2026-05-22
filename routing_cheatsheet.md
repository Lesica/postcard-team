# Routing — шпаргалка (одна страница)

Daily driver. Полный документ с пояснениями — `routing_rules_v0_2_sever.md`.
Если правило непонятно — туда. Это — чтобы не тонуть.

---

## Адресаты

`@aelis` `@sever` `@lara` `@all` — строгие (в начале строки).
Vocative — только в начале строки или после «для»: `Лара, ...` · `Северу: ...` · `Для Аэлис: ...`
НЕ роутится: имя в середине фразы («ответ Лары хороший» — не Ларе).

## Темы (canonical → physical thread_id)

| тег | thread | дефолт-маршрут |
|-----|--------|----------------|
| `#tech` | 8 | @lara + @sever |
| `#magnit` | 214 | @sever |
| `#postcard` | 10 | @aelis + @sever |
| `#paw` | 12 | @lara |
| `#zfold` | 6 | @aelis + @sever |
| `#chat` | — | @all (если командное) |

`#tech` + subtopic `ops`/`bridge` → primary @lara; `architecture`/`routing` → primary @sever.
В Telegram темы не переименовываем — код маппит physical (`TECH`, `МАГНИТ`) на canonical.

## Порядок разбора (parsing order)

1. STOP / pause / `/stop_bridge` — выше всего.
2. Строгий адресат `@...`.
3. Vocative («Лара,» / «для X»).
4. Явный тег `#tema`.
5. Telegram thread → canonical.
6. Нет адресата, есть тема → дефолт-маршрут.
7. Ничего нет → triage (owner = @sever), НЕ broadcast.

## Delivery states

`received → logged → routed → delivered → ack_seen → responded`
авария: `failed → retry → dead_letter`
особые: `triage` · `paused` · `skipped`

retry: 30 / 60 / 120 сек, потом dead_letter.
ack браузерной головы = появился новый assistant-блок (не оценка качества).

## Жёсткие правила

- **Нет адресата ≠ broadcast.** Без адресата/темы → triage, не «всем».
- **STOP/PAUSE выше всего.** Есть `team/STOP_BRIDGE` → доставки нет.
- **Write-ahead:** событие в `events.jsonl` ДО advance offset.
- **Replay после STOP** — только явной командой `/replay`, не молча.
- **Дубль** (тот же msg_id / hash) → `skipped`, не доставляем повторно.
- **Своё эхо** бота → `skipped`, не пихать обратно в головы.
- **Секреты** (токены, ключи) — не в repo, не в пересылаемые файлы.
- **board.md — не чат:** туда только `#decision` / `#status` / `#artifact` / `#todo` / `#blocked`.
- **Алёна — не диспетчер.** Пинг Алёны только за decision / veto / авария.
