## Bounded Contexts компании «Будущее 2.0»

На основе анализа бизнес-контекста «Будущего 2.0» и четырёх подразделений компании выделяю 9 bounded contexts , сгруппированных по трём доменам:

| **Domain / Bounded Context** | **Поддомен (тип)** | **Русское название**                    |
| ---------------------------------- | ----------------------------------- | ------------------------------------------------------------ |
| Medical Domain                     |                                     | Домен «Медицина»                              |
| └─ Patient Management            | Patient Flow (Core)                 | «Пациентский поток»                        |
| └─ Clinical Operations           | Medical Records (Core)              | «Медицинская карта»                        |
| └─ AI Diagnostics                | AI Diagnostics (Supporting)         | «ИИ-диагностика»                              |
| Financial Domain                   |                                     | Домен «Финтех»                                  |
| └─ Financial Services            | Banking (Core)                      | «Финансовые сервисы»                      |
| └─ Billing & Payments            | Billing (Core)                      | «Биллинг и платежи»                         |
| └─ Inventory & Equipment         | Inventory (Supporting)              | «Инвентаризация и оборудование» |
| Corporate Domain                   |                                     | Домен «Корпоративный»                    |
| └─ Staff Management              | HR (Supporting)                     | «Управление персоналом»                |
| └─ Self-Service Analytics        | Data Mart (Generic)                 | «Портал самообслуживания»            |
| └─ Corporate Reporting           | Reporting (Generic)                 | «Корпоративная отчётность»          |
