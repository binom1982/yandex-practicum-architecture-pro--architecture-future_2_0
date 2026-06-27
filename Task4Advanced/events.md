# Каталог доменных событий «Будущее 2.0»

Документ описывает доменные события, публикуемые каждым Bounded Context.
Для каждого события указаны: источник, семантика, минимальный контракт и подписчики.

---

## Общие принципы именования и контрактов

- **Формат имени:** `<Существительное в прошедшем времени>` (например, `PatientRegistered`, `VisitCompleted`).
- **Семантика:** событие констатирует факт, который **уже произошёл** в домене-источнике. Подписчик не может отклонить событие.
- **Идемпотентность:** все события несут `eventId` (UUID) — подписчик обязан гарантировать идемпотентную обработку.
- **Контракт:** описывается в формате Avro/Protobuf и регистрируется в Schema Registry.
- **Версионирование:** контракт версионируется, обратная совместимость обязательна.

---

## Домен «Медицина» (Medical Domain)

### Bounded Context: «Пациентский поток» (Patient Management)

| Событие | Семантика | Минимальный контракт | Подписчики |
|---------|-----------|----------------------|------------|
| `PatientRegistered` | Зарегистрирован новый пациент | `patientId`, `policyNumber`, `registeredAt` | Биллинг, Портал самообслуживания, Управление персоналом |
| `PatientUpdated` | Обновлены данные пациента | `patientId`, `changedFields[]`, `updatedAt` | Портал самообслуживания |
| `PatientArchived` | Пациент переведён в архив | `patientId`, `archivedAt`, `reason` | Биллинг, Корпоративная отчётность |
| `AppointmentCreated` | Создана запись на приём | `appointmentId`, `patientId`, `doctorId`, `timeSlot` | ИИ-диагностика, Инвентаризация |
| `AppointmentCancelled` | Запись отменена | `appointmentId`, `cancelledAt`, `reason` | Биллинг, Инвентаризация |
| `AppointmentRescheduled` | Запись перенесена | `appointmentId`, `oldTimeSlot`, `newTimeSlot` | Биллинг |
| `VisitStarted` | Визит начат | `visitId`, `patientId`, `doctorId`, `startedAt` | Биллинг |
| `VisitCompleted` | Визит завершён | `visitId`, `patientId`, `completedAt`, `serviceIds[]` | Биллинг, Портал самообслуживания |
| `VisitCancelled` | Визит отменён | `visitId`, `cancelledAt`, `reason` | Биллинг |

### Bounded Context: «Медицинская карта» (Clinical Operations)

| Событие | Семантика | Минимальный контракт | Подписчики |
|---------|-----------|----------------------|------------|
| `DiagnosisMade` | Установлен диагноз | `medicalRecordId`, `patientId`, `diagnosisCode`, `diagnosedAt` | ИИ-диагностика, Портал самообслуживания |
| `PrescriptionCreated` | Выписан рецепт | `prescriptionId`, `patientId`, `medicationIds[]`, `createdAt` | Портал самообслуживания |
| `MedicalRecordUpdated` | Обновлена медицинская карта | `medicalRecordId`, `patientId`, `updatedAt` | Портал самообслуживания |
| `StudyRequested` | Запрошено исследование | `studyId`, `patientId`, `visitId`, `studyType` | ИИ-диагностика, Инвентаризация |
| `StudyCompleted` | Исследование проведено | `studyId`, `patientId`, `completedAt`, `resultRef` | ИИ-диагностика, Портал самообслуживания |
| `StudyResultAttached` | К исследованию прикреплён результат | `studyId`, `attachmentRef`, `attachedAt` | ИИ-диагностика |

### Bounded Context: «ИИ-диагностика» (AI Diagnostics)

| Событие | Семантика | Минимальный контракт | Подписчики |
|---------|-----------|----------------------|------------|
| `AIStudyRequested` | Запрошен ИИ-анализ | `aiStudyId`, `studyId`, `modelId`, `requestedAt` | — (внутреннее) |
| `AIStudyCompleted` | ИИ-анализ завершён | `aiStudyId`, `studyId`, `modelVersion`, `completedAt` | Медицинская карта |
| `AIReportReady` | Готов отчёт ИИ | `aiStudyId`, `reportRef`, `confidence`, `readyAt` | Медицинская карта, Портал самообслуживания |
| `ModelRegistered` | Зарегистрирована новая модель | `modelId`, `version`, `registeredAt` | — (внутреннее) |
| `ModelPromoted` | Модель переведена в Production | `modelId`, `version`, `promotedAt` | — (внутреннее) |
| `ModelDeprecated` | Модель выведена из эксплуатации | `modelId`, `version`, `deprecatedAt` | — (внутреннее) |

---

## Домен «Финтех» (Financial Domain)

### Bounded Context: «Финансовые сервисы» (Financial Services)

| Событие | Семантика | Минимальный контракт | Подписчики |
|---------|-----------|----------------------|------------|
| `AccountOpened` | Открыт банковский счёт | `accountId`, `patientId`, `openedAt`, `currency` | Биллинг, Портал самообслуживания |
| `TransactionCompleted` | Проведена транзакция | `transactionId`, `accountId`, `amount`, `completedAt` | Биллинг, Корпоративная отчётность |
| `AccountClosed` | Счёт закрыт | `accountId`, `closedAt`, `finalBalance` | Биллинг |
| `CreditAgreementCreated` | Создан кредитный договор | `creditId`, `patientId`, `amount`, `createdAt` | Биллинг, Портал самообслуживания |
| `CreditApproved` | Кредит одобрен | `creditId`, `approvedAmount`, `rate`, `approvedAt` | Биллинг |
| `CreditDisbursed` | Кредит выдан | `creditId`, `disbursedAmount`, `disbursedAt` | Биллинг, Корпоративная отчётность |

### Bounded Context: «Биллинг и платежи» (Billing & Payments)

| Событие | Семантика | Минимальный контракт | Подписчики |
|---------|-----------|----------------------|------------|
| `InvoiceCreated` | Выставлен счёт | `invoiceId`, `patientId`, `visitId`, `amount`, `createdAt` | Финансовые сервисы, Портал самообслуживания |
| `InvoicePaid` | Счёт оплачен | `invoiceId`, `paidAt`, `paymentId` | Финансовые сервисы, Корпоративная отчётность |
| `InvoiceCancelled` | Счёт отменён | `invoiceId`, `cancelledAt`, `reason` | Финансовые сервисы |
| `PaymentInitiated` | Платёж инициирован | `paymentId`, `invoiceId`, `amount`, `initiatedAt` | Финансовые сервисы |
| `PaymentProcessed` | Платёж обработан банком | `paymentId`, `status`, `processedAt` | Биллинг |
| `PaymentReconciled` | Платёж сверён с реестром | `paymentId`, `reconciledAt`, `reconciliationRef` | Корпоративная отчётность |

### Bounded Context: «Инвентаризация и оборудование» (Inventory & Equipment)

| Событие | Семантика | Минимальный контракт | Подписчики |
|---------|-----------|----------------------|------------|
| `EquipmentAllocated` | Оборудование зарезервировано | `equipmentId`, `visitId`, `allocatedAt` | Пациентский поток |
| `EquipmentMaintained` | Оборудование обслужено | `equipmentId`, `maintainedAt`, `nextMaintenanceAt` | Пациентский поток, Корпоративная отчётность |
| `EquipmentDecommissioned` | Оборудование списано | `equipmentId`, `decommissionedAt`, `reason` | Корпоративная отчётность |
| `StockReceived` | Товар принят на склад | `itemId`, `quantity`, `receivedAt` | Корпоративная отчётность |
| `StockConsumed` | Товар списан в расход | `itemId`, `visitId`, `quantity`, `consumedAt` | Биллинг, Корпоративная отчётность |
| `StockAdjusted` | Проведена инвентаризация | `itemId`, `oldQuantity`, `newQuantity`, `adjustedAt` | Корпоративная отчётность |

---

## Домен «Корпоративный» (Corporate Domain)

### Bounded Context: «Управление персоналом» (Staff Management)

| Событие | Семантика | Минимальный контракт | Подписчики |
|---------|-----------|----------------------|------------|
| `EmployeeHired` | Сотрудник принят на работу | `employeeId`, `role`, `hiredAt` | Пациентский поток |
| `RoleGranted` | Сотруднику выдана роль | `employeeId`, `role`, `grantedAt` | Портал самообслуживания |
| `EmployeeTerminated` | Сотрудник уволен | `employeeId`, `terminatedAt` | Пациентский поток, Портал самообслуживания |
| `SchedulePublished` | Опубликован график | `employeeId`, `period`, `publishedAt` | Пациентский поток |
| `ScheduleUpdated` | График изменён | `employeeId`, `changedSlots[]`, `updatedAt` | Пациентский поток |
| `AbsenceRegistered` | Зарегистрировано отсутствие | `employeeId`, `from`, `to`, `reason` | Пациентский поток |

### Bounded Context: «Портал самообслуживания» (Self-Service Analytics)

| Событие | Семантика | Минимальный контракт | Подписчики |
|---------|-----------|----------------------|------------|
| `DataMartCreated` | Создана витрина данных | `dataMartId`, `domain`, `ownerId`, `createdAt` | Корпоративная отчётность |
| `DataMartUpdated` | Витрина обновлена | `dataMartId`, `updatedAt`, `schemaVersion` | Корпоративная отчётность |
| `AccessGranted` | Предоставлен доступ к витрине | `dataMartId`, `userId`, `role`, `grantedAt` | — (внутреннее) |
| `TemplateCreated` | Создан шаблон отчёта | `templateId`, `authorId`, `createdAt` | — (внутреннее) |
| `TemplatePublished` | Шаблон опубликован | `templateId`, `publishedAt`, `visibility` | — (внутреннее) |
| `TemplateExecuted` | Отчёт по шаблону сформирован | `templateId`, `executedAt`, `resultRef` | Корпоративная отчётность |

### Bounded Context: «Корпоративная отчётность» (Corporate Reporting)

| Событие | Семантика | Минимальный контракт | Подписчики |
|---------|-----------|----------------------|------------|
| `KPICalculated` | Рассчитан KPI | `kpiId`, `period`, `value`, `calculatedAt` | — (внутреннее) |
| `ReportGenerated` | Сформирован отчёт | `reportId`, `reportType`, `period`, `generatedAt` | — (внутреннее) |
| `ReportSubmitted` | Отчёт отправлен | `reportId`, `submittedAt`, `recipient` | — (внутреннее) |
| `SubmissionPrepared` | Регуляторная отчётность подготовлена | `submissionId`, `period`, `preparedAt` | — (внутреннее) |
| `SubmissionSent` | Отчёт отправлен регулятору | `submissionId`, `sentAt`, `format` | — (внутреннее) |
| `SubmissionAccepted` | Регулятор принял отчёт | `submissionId`, `acceptedAt`, `confirmationRef` | — (внутреннее) |

---

## Матрица «Событие → Подписчики» (ключевые междоменные потоки)

| Событие | Источник | Ключевые подписчики |
|---------|----------|---------------------|
| `PatientRegistered` | Пациентский поток | Биллинг, Портал самообслуживания |
| `VisitCompleted` | Пациентский поток | Биллинг, Портал самообслуживания |
| `StudyRequested` | Медицинская карта | ИИ-диагностика, Инвентаризация |
| `AIReportReady` | ИИ-диагностика | Медицинская карта, Портал самообслуживания |
| `InvoiceCreated` | Биллинг | Финансовые сервисы, Портал самообслуживания |
| `PaymentReconciled` | Биллинг | Корпоративная отчётность |
| `EquipmentAllocated` | Инвентаризация | Пациентский поток |
| `SchedulePublished` | Управление персоналом | Пациентский поток |
| `DataMartCreated` | Портал самообслуживания | Корпоративная отчётность |

---

## Принципы публикации и потребления

1. **At-least-once доставка:** все события доставляются с гарантией «хотя бы раз». Подписчик обязан быть идемпотентным.
2. **Dead Letter Queue (DLQ):** при повторных ошибках обработки событие уходит в DLQ для ручного разбора.
3. **События не несут ПМД:** персональные медицинские данные (диагнозы, анамнез, снимки) **никогда** не попадают в события для Портала самообслуживания и Корпоративной отчётности — только ссылки и агрегированные факты.
4. **Compliance-граница финтеха:** события между Медицинским доменом и Финтех-доменом проходят через Anti-Corruption Layer (ACL) и содержат только обезличенные идентификаторы.
5. **События — контракт домена:** источник владеет схемой события. Подписчик не имеет права менять контракт в одностороннем порядке.