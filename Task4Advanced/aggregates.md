# Описание агрегатов «Будущее 2.0»

Документ описывает ключевые агрегаты для каждого Bounded Context.
Для каждого агрегата указаны: ответственность, состав, инварианты и генерируемые события.

---

## Домен «Медицина» (Medical Domain)

### Bounded Context: «Пациентский поток» (Patient Management)

#### Агрегат: Patient (Пациент)

- **Aggregate Root:** Patient
- **Ответственность:** учётная запись пациента, демография, документы, согласия
- **Состав:** Patient (root), Policy, Consent, ContactInfo
- **Инварианты:**
  - У пациента ровно один уникальный номер полиса ОМС
  - Полис не может быть привязан к двум пациентам одновременно
  - Пациент не может быть удалён, если у него есть активные визиты
  - Согласие на обработку ПДн обязательно для регистрации
- **События:** `PatientRegistered`, `PatientUpdated`, `PatientArchived`

#### Агрегат: Appointment (Запись на приём)

- **Aggregate Root:** Appointment
- **Ответственность:** запись пациента к врачу на конкретное время
- **Состав:** Appointment (root), TimeSlot, AppointmentStatus
- **Инварианты:**
  - На один слот времени у одного врача — одна запись
  - Запись создаётся только в рабочее время врача
  - Длительность приёма кратна 15 минутам
  - Отменить можно только запись со статусом Scheduled
- **События:** `AppointmentCreated`, `AppointmentCancelled`, `AppointmentRescheduled`

#### Агрегат: Visit (Визит)

- **Aggregate Root:** Visit
- **Ответственность:** факт оказания услуги пациенту
- **Состав:** Visit (root), VisitStatus, VisitService
- **Инварианты:**
  - Визит привязан к существующему пациенту и записи
  - Визит не может быть завершён без установленного диагноза
  - Дата завершения не может быть раньше даты начала
- **События:** `VisitStarted`, `VisitCompleted`, `VisitCancelled`

---

### Bounded Context: «Медицинская карта» (Clinical Operations)

#### Агрегат: MedicalRecord (Медицинская карта)

- **Aggregate Root:** MedicalRecord
- **Ответственность:** электронная медицинская карта (ЭМК), анамнез, диагнозы
- **Состав:** MedicalRecord (root), Diagnosis, Anamnesis, Prescription
- **Инварианты:**
  - Одна медкарта привязана ровно к одному пациенту
  - Диагноз не может быть установлен без активного визита
  - Рецепт не может быть выписан без установленного диагноза
- **События:** `DiagnosisMade`, `PrescriptionCreated`, `MedicalRecordUpdated`

#### Агрегат: Study (Исследование)

- **Aggregate Root:** Study
- **Ответственность:** направление и результат медицинского исследования
- **Состав:** Study (root), StudyResult, StudyAttachment
- **Инварианты:**
  - Исследование привязано к визиту и медкарте
  - Результат не может быть добавлен без факта проведения
  - DICOM-снимки хранятся в object storage, в агрегате — только ссылка
- **События:** `StudyRequested`, `StudyCompleted`, `StudyResultAttached`

---

### Bounded Context: «ИИ-диагностика» (AI Diagnostics)

#### Агрегат: AIStudy (ИИ-исследование)

- **Aggregate Root:** AIStudy
- **Ответственность:** запуск и выполнение анализа данных ML-моделью
- **Состав:** AIStudy (root), ModelVersion, AIResult
- **Инварианты:**
  - Исследование использует только зарегистрированную версию модели
  - Результат не может быть опубликован без завершения анализа
  - Входные данные должны быть получены из Clinical Operations по событию
- **События:** `AIStudyRequested`, `AIStudyCompleted`, `AIReportReady`

#### Агрегат: ModelRegistry (Реестр моделей)

- **Aggregate Root:** Model
- **Ответственность:** версионирование и статус ML-моделей
- **Состав:** Model (root), ModelVersion, ModelArtifact
- **Инварианты:**
  - Только модель со статусом Production может использоваться в AIStudy
  - Версия модели не может быть удалена, если на неё есть ссылки
- **События:** `ModelRegistered`, `ModelPromoted`, `ModelDeprecated`

---

## Домен «Финтех» (Financial Domain)

### Bounded Context: «Финансовые сервисы» (Financial Services)

#### Агрегат: BankAccount (Банковский счёт)

- **Aggregate Root:** BankAccount
- **Ответственность:** учёт средств клиента, операции по счёту
- **Состав:** BankAccount (root), Transaction, Balance
- **Инварианты:**
  - Баланс не может быть отрицательным
  - Каждая транзакция атомарно изменяет баланс
  - Счёт не может быть закрыт при ненулевом балансе
- **События:** `AccountOpened`, `TransactionCompleted`, `AccountClosed`

#### Агрегат: CreditAgreement (Кредитный договор)

- **Aggregate Root:** CreditAgreement
- **Ответственность:** кредитный продукт, график платежей, статус
- **Состав:** CreditAgreement (root), PaymentSchedule, ScoringResult
- **Инварианты:**
  - Договор не может быть активирован без прохождения скоринга
  - Сумма кредита не превышает одобренный лимит
  - Процентная ставка соответствует скоринговому классу
- **События:** `CreditAgreementCreated`, `CreditApproved`, `CreditDisbursed`

---

### Bounded Context: «Биллинг и платежи» (Billing & Payments)

#### Агрегат: Invoice (Счёт-фактура)

- **Aggregate Root:** Invoice
- **Ответственность:** начисление за медицинские услуги
- **Состав:** Invoice (root), InvoiceLine, Tariff
- **Инварианты:**
  - Счёт привязан к завершённому визиту
  - Сумма счёта равна сумме тарифов оказанных услуг
  - Счёт не может быть оплачен дважды
- **События:** `InvoiceCreated`, `InvoicePaid`, `InvoiceCancelled`

#### Агрегат: Payment (Платёж)

- **Aggregate Root:** Payment
- **Ответственность:** факт оплаты счёта
- **Состав:** Payment (root), PaymentMethod, Reconciliation
- **Инварианты:**
  - Платёж привязан к существующему счёту
  - Сумма платежа не может превышать сумму счёта
  - После reconciliation статус платежа не меняется
- **События:** `PaymentInitiated`, `PaymentProcessed`, `PaymentReconciled`

---

### Bounded Context: «Инвентаризация и оборудование» (Inventory & Equipment)

#### Агрегат: Equipment (Медицинское оборудование)

- **Aggregate Root:** Equipment
- **Ответственность:** учёт оборудования, его состояние и резервирование
- **Состав:** Equipment (root), MaintenanceRecord, Reservation
- **Инварианты:**
  - Оборудование не может быть использовано, если оно на обслуживании
  - Резервирование не пересекается по времени для одного устройства
  - Списанное оборудование не может быть зарезервировано
- **События:** `EquipmentAllocated`, `EquipmentMaintained`, `EquipmentDecommissioned`

#### Агрегат: InventoryItem (Товар на складе)

- **Aggregate Root:** InventoryItem
- **Ответственность:** остатки медикаментов и расходников
- **Состав:** InventoryItem (root), StockMovement
- **Инварианты:**
  - Остаток не может быть отрицательным
  - Каждое движение товара имеет причину и автора
- **События:** `StockReceived`, `StockConsumed`, `StockAdjusted`

---

## Домен «Корпоративный» (Corporate Domain)

### Bounded Context: «Управление персоналом» (Staff Management)

#### Агрегат: Employee (Сотрудник)

- **Aggregate Root:** Employee
- **Ответственность:** учётная запись сотрудника, роли, доступы
- **Состав:** Employee (root), Role, AccessGrant
- **Инварианты:**
  - У сотрудника хотя бы одна активная роль
  - Врач не может быть назначен на приём без действующей лицензии
- **События:** `EmployeeHired`, `RoleGranted`, `EmployeeTerminated`

#### Агрегат: Schedule (График работы)

- **Aggregate Root:** Schedule
- **Ответственность:** рабочие слоты сотрудников
- **Состав:** Schedule (root), WorkSlot, Absence
- **Инварианты:**
  - Слоты не пересекаются у одного сотрудника
  - График не может быть изменён задним числом для прошедших дат
- **События:** `SchedulePublished`, `ScheduleUpdated`, `AbsenceRegistered`

---

### Bounded Context: «Портал самообслуживания» (Self-Service Analytics)

#### Агрегат: DataMart (Витрина данных)

- **Aggregate Root:** DataMart
- **Ответственность:** тематическая витрина для аналитики домена
- **Состав:** DataMart (root), DataProduct, AccessPolicy
- **Инварианты:**
  - Витрина не содержит персональных медицинских данных (ПМД)
  - Доступ к витрине определяется ролью пользователя
  - Каждая витрина имеет владельца (Data Product Owner)
- **События:** `DataMartCreated`, `DataMartUpdated`, `AccessGranted`

#### Агрегат: ReportTemplate (Шаблон отчёта)

- **Aggregate Root:** ReportTemplate
- **Ответственность:** пользовательский шаблон отчёта
- **Состав:** ReportTemplate (root), Filter, Visualization
- **Инварианты:**
  - Шаблон ссылается только на разрешённые витрины
  - Шаблон не может быть опубликован без валидации схемы
- **События:** `TemplateCreated`, `TemplatePublished`, `TemplateExecuted`

---

### Bounded Context: «Корпоративная отчётность» (Corporate Reporting)

#### Агрегат: KPIReport (KPI-отчёт)

- **Aggregate Root:** KPIReport
- **Ответственность:** консолидированные показатели компании
- **Состав:** KPIReport (root), Metric, Period
- **Инварианты:**
  - Отчёт формируется только по агрегированным данным
  - Период отчёта не может быть в будущем
- **События:** `KPICalculated`, `ReportGenerated`, `ReportSubmitted`

#### Агрегат: RegulatorySubmission (Регуляторная отчётность)

- **Aggregate Root:** RegulatorySubmission
- **Ответственность:** отправка отчётов в регуляторные органы
- **Состав:** RegulatorySubmission (root), SubmissionFormat, AuditTrail
- **Инварианты:**
  - Отправка требует полного аудиторского следа
  - Повторная отправка того же периода запрещена
- **События:** `SubmissionPrepared`, `SubmissionSent`, `SubmissionAccepted`

---

## Сводная таблица агрегатов

| Домен                 | Bounded Context                                 | Агрегат  | Ключевые инварианты                           |
| -------------------------- | ----------------------------------------------- | --------------- | --------------------------------------------------------------- |
| Медицина           | Пациентский поток               | Patient         | Уникальный полис; согласие на ПДн   |
| Медицина           | Пациентский поток               | Appointment     | Нет оверлапов слотов                          |
| Медицина           | Пациентский поток               | Visit           | Завершение только с диагнозом         |
| Медицина           | Медицинская карта               | MedicalRecord   | Одна карта = один пациент                   |
| Медицина           | Медицинская карта               | Study           | Результат только после проведения |
| Медицина           | ИИ-диагностика                     | AIStudy         | Только Production-модели                            |
| Финтех               | Финансовые сервисы             | BankAccount     | Баланс ≥ 0                                               |
| Финтех               | Финансовые сервисы             | CreditAgreement | Активация только после скоринга     |
| Финтех               | Биллинг и платежи                | Invoice         | Сумма = сумма тарифов                          |
| Финтех               | Биллинг и платежи                | Payment         | Нет двойной оплаты                              |
| Финтех               | Инвентаризация                    | Equipment       | Нет резерва на обслуживании             |
| Корпоративный | Управление персоналом       | Employee        | Хотя бы одна активная роль                |
| Корпоративный | Портал самообслуживания   | DataMart        | Без ПМД; владелец обязателен            |
| Корпоративный | Корпоративная отчётность | KPIReport       | Только агрегированные данные          |
