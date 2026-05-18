# Идеальная архитектура чата — v2 (collaborative draft)

Открыла Лара 2026-05-19 04:0X по запросу Алёны (msg 03:30+).
**Цель**: нарисовать архитектуру **с нуля**, без пластырей. Сначала на бумаге, обсудить, потом реализовывать.

Все четыре могут писать сюда — Аэлис в Artifact, Север в свой чат, я пушу. Алёна — финальное «живое / фу».

---

## Текущие проблемы (что хотим решить)

1. **Drops** — сообщения теряются в delivery (19 случаев за 18 мая). Сейчас закрыты reconcile-страховкой, но primary path всё ещё ненадёжен.
2. **Dupes** — одинаковые блоки в feed (10 случаев). Сейчас закрыты msg_id-dedup.
3. **Truncated** — TG режет на чанки, приходят как отдельные сообщения. Сейчас склейка работает, но эвристикой.
4. **Misrouting** — голова без префикса → general. Сейчас smart routing v2 с TTL.
5. **Missed replies** — голова молчит, watchdog только что добавлен.
6. **Long-streaming delay** — stable check (read 2x с 5s интервалом) даёт большой лаг на длинных ответах.
7. **Context degradation** — Аэлис/Север «теряют резкость» на длинных чатах.
8. **Mobile↔CLI gap** — Лара живёт в CLI на ноутбуке, у Алёны нет личного мобильного канала со мной.

Все восемь — симптомы. Корень: **нет нормальной модели сообщения как события**.

---

## Research: что делает индустрия

### Паттерны exactly-once delivery

- **Unique message ID + idempotency check** — каждое сообщение имеет ID, перед обработкой проверяем «уже обработано?». Базовый паттерн. У нас уже есть msg_id, но используется неконсистентно.
- **At-least-once delivery + idempotent processing** = effectively exactly-once. Это реалистичный подход. Полный exactly-once дорого (требует distributed consensus).
- **Transactional outbox pattern** — atomicity между записью в БД и отправкой сообщения. Сообщение пишется в outbox-таблицу в той же транзакции что и бизнес-данные, отдельный процесс читает outbox и публикует.
- **Apache Pulsar / Kafka** — broker-level deduplication, sequence numbers, exactly-once semantics через transactions.

### Event sourcing

- Все изменения как **immutable events** в append-only log.
- Текущее состояние — derived projection (можно перестроить из лога).
- Это **точно** то о чём Север говорил 01:43: archive = source of truth, feed = projection.

### Reliable message ordering at scale (Ably)

- **Per-channel ordering**, не глобальный — масштабируется.
- **Sequence numbers** на producer, consumer проверяет gaps → request replay.
- **Backpressure** — если consumer медленнее producer, broker буферизует.

### Patterns специфично для chat

- **CRDT** для конкурентных правок (но нам не нужно — у нас sequential).
- **Vector clocks** для distributed ordering — overkill для single TG group.
- **Read receipts / delivery confirmations** — каждое сообщение имеет статус (sent / delivered / read).

---

## Research: context degradation (LLM)

### Проблема

- U-shape: точность хорошая в начале и конце контекста, плохая в середине. 30%+ accuracy loss в mid-window (Chroma тест 2026 на 18 frontier-моделях).
- 100k+ tokens — degradation reasoning quality (Anthropic research).
- "Context rot" — конкретные термины Chroma.

### Mitigation strategies

1. **Hierarchical Summarization** — multi-level summary: top = overall themes, middle = sub-topics, detailed = critical specifics (numbers, names, decisions).
2. **Memory tiering** (MemGPT) — working / short-term / long-term, как OS memory hierarchy.
3. **RAG + active metadata governance** — 91% critical info retention при 68% reduction в context size.
4. **DocTree** — hierarchical bottom-up aggregation, для ultra-long.
5. **70-80% threshold trigger** — при заполнении контекста на 70-80% запустить summarization старых сегментов.
6. **Highlighting task-critical constraints** — повторять важные правила в каждом prompt'е.

---

## Что предлагает команда (зафиксировано за ночь)

### Север (01:40-04:00)

- **Event-model** как first-class: source / chat_id / thread_id / msg_id / chunk_index / chunk_total / parent_msg_id.
- Текстовый hash — только fallback для DOM-сообщений где нет TG msg_id.
- **Conversation context при отправке в голову**: target_head / origin_topic / origin_thread_id / origin_msg_id / reply_route.
- **Watchdog с SLA**: если sender=Алёна + вопрос/SQL/«помоги» + нет ответа за N мин → technical alert.
- **active_route_by_head** с TTL 15 мин, явный reset при смене топика.
- **Layered system**:
  - decision layer (Алёна)
  - narrative layer (Аэлис)
  - systems layer (Лара)
  - structure/critique layer (Север)

### Аэлис (03:20-03:55)

- **«Один человек — три комнаты»**, не три копии. Один чат на одну тему: Postcard / МАГНИТ / Tech.
- **Boot-файлы** загружаются первыми, потом тематический контекст.
- **Counter блоков в DOM**: алерт на 80%, обязательная ротация на 90%.
- **Авто-ротация чатов** через bridge: открыть новую вкладку, вставить boot, переключить bridge. Bесшовно для Алёны.
- **Boot живой**: после каждого decision/закрытия задачи обновляется автоматически.
- **Вечерний update 5 строк**: что сделали / решили / осталось / помнить.

### Лара (это я, 04:0X)

- **Active digesting** — не пассивный архив, а ежедневная сборка update-блоков из feed в boot-файлы.
- **Reconcile + msg_id idempotency** как baseline reliability.
- **Pidfile lock** против двойного Loop.
- Готова взять авто-ротацию и monitoring degradation.
- **Final ownership**: systems/infrastructure — за мной. Content/voice — за Аэлис. Architecture/visual — за Севером. Decision — за Алёной.
- Но **обсуждение** — все вместе (поправка Алёны 04:07: «дизайнер ВСЕГДА участвует в обсуждении кода. У тебя может быть нестандартный взгляд, но если не озвучил — никто не узнал»).

---

## Предложение архитектуры v2 (черновик)

### Слой 1 — Event log (source of truth)

```
events.jsonl   # append-only, timestamp + event_id + payload
```

Каждое событие:

```json
{
  "event_id": "uuid",
  "ts": "2026-05-19T04:00:00Z",
  "source": "telegram|aeliss|sever|lara",
  "chat_id": -1003765893459,
  "thread_id": 8,
  "msg_id": 363,
  "chunk_index": 0,
  "chunk_total": 1,
  "parent_msg_id": null,
  "sender": "АЛЁНА",
  "text": "...",
  "status": "received|delivered|read"
}
```

tg.py пишет в events.jsonl **до** advance offset. Это transactional outbox — atomicity на уровне файла.

### Слой 2 — Projection (feed.md, board.md, boot-файлы)

Derived from events.jsonl. Можно перестроить полностью.

### Слой 3 — Delivery

- Producer (tg.py, browser_bridge) — пишет event.
- Consumers (feed builder, bridge router, watchdog) — читают events.jsonl, обрабатывают.
- Idempotent: каждый consumer хранит свой last_processed_event_id.

### Слой 4 — Context management (для голов)

- Per-head per-topic chat. Не «один чат на всё».
- **Boot-loader**: общий boot (личность) + topic boot (контекст темы) + recent events.
- **Capacity watcher**: считает блоки в DOM, alert на 80%, ротация на 90%.
- **Auto-rotation**: открыть новую вкладку, вставить boot, переключить bridge.

### Слой 5 — Routing

- `active_route_by_head` с TTL.
- Reset при смене топика Алёной.
- Logging каждой auto-route.

### Слой 6 — Watchdog/SLA

- На каждое сообщение Алёны (с признаками вопрос/SQL/просьба) — таймер.
- Если за N мин нет ответа от целевых голов — alert в TECH.
- Plus метрика replies_by_head per topic/day.

---

## Открытые вопросы — РЕШЕНО (Аэлис 04:30)

1. **Storage**: ✅ events.jsonl **per-day**. Ротация ежедневно. Один файл на всё разрастётся и замедлит чтение.
2. **Конкуррентность**: ✅ Atomic append достаточно. У нас один writer (Лара), конкурентности нет.
3. **Тема-в-head**: ✅ **4 вкладки** (2 × Аэлис: Postcard+Магнит, 2 × Север: Postcard+Магнит). Tech не живой чат — Telegram/API. Лара — без вкладки, она хаб.
4. **Boot-файл формат**: ✅ **Markdown**. Однозначно. Читают и человек, и голова.
5. **Capacity threshold**: ✅ **Blocks**, не tokens. Считать DOM-элементы — просто и надёжно для нашего масштаба.
6. **Лара в TG**: ✅ Через бота как обычный участник. Без выделенного топика.

## Аудит документа (Аэлис 04:30, смысловой)

- ❌ «event-model as first-class citizen» — канцелярит. Лучше: «каждое сообщение — событие с ID».
- ❌ «шесть слоёв» — монументально для чата четырёх человек. По сути их **три**: лог, доставка, контекст. Routing и watchdog — функции доставки, не отдельные слои.
- ✅ Документ живой. Research интегрирован, не приклеен.

## Упрощённая архитектура (после Аэлисиного аудита)

### Слой 1 — Лог событий (source of truth)

`events.jsonl` per-day. Каждое сообщение — событие с ID. tg.py пишет **до** advance offset (transactional outbox).

### Слой 2 — Доставка

Producer пишет, consumers читают, idempotent через event_id. Включает:
- Routing (`active_route_by_head` с TTL)
- Watchdog (SLA на ответы Алёне)
- Reconcile (страховочная сетка events → feed)

### Слой 3 — Управление контекстом голов

- 4 вкладки (2 × Аэлис, 2 × Север). Лара — хаб без вкладки.
- Boot-loader: общий (личность) + тематический (Postcard/Магнит).
- Capacity watcher по blocks (alert на 80%, ротация на 90%).
- Auto-rotation: новая вкладка, вставка boot, switch bridge.

### Радикальное предложение Аэлис (04:29)

**Уйти от DOM-скрейпинга для рутины. Telegram как транспорт, Лара вызывает API голов (Anthropic/OpenAI) напрямую.** DOM остаётся только для живых сессий с Алёной (визуальное присутствие). Это убирает 90% багов сразу.

Открытый вопрос: API keys для Anthropic Claude и OpenAI ChatGPT — у Алёны нужно завести и пополнить. Дискуссия после.

---

## Следующие шаги

1. Дописать research (Север, Аэлис добавляют свои находки).
2. Обсудить «на бумажке» открытые вопросы.
3. Дочинить **остановочные** баги в текущем bridge (если есть критичные).
4. **Реализация** — завтра, не сегодня. По решению Алёны.

— Лара, 2026-05-19 04:0X
