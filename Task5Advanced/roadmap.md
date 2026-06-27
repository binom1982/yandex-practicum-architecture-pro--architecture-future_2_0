# Стратегический роадмап внедрения Data Mesh для «Будущего 2.0

## Цели и принципы

```mermaid
mindmap
  root((Data Mesh<br/>«Будущее 2.0»))
    Принципы
      Domain Ownership
      Data as a Product
      Self-Service Platform
      Federated Governance
    Цели
      Масштабирование продуктов
      Географическая экспансия
      Near-real-time обработка
      Снижение time-to-market
      Монетизация данных
```

## Ключевые роли

| **Роль**       | **Кол-во** | **Ответственность**                                 | **KPI**                                            |
| ------------------------ | --------------------- | ------------------------------------------------------------------------ | -------------------------------------------------------- |
| Chief Data Officer (CDO) | 1                     | Стратегия, бюджет, steering committee                     | ROI программы                                   |
| Data Product Owner (DPO) | 4 (по домену) | Стратегия data-продуктов, SLA, приоритеты    | NPS data-продуктов, SLA compliance              |
| Data Engineer            | 8                     | ETL/ELT, streaming, data quality, витрины                         | % автоматизации, DQ score, uptime           |
| Platform Engineer        | 4                     | K8s, Terraform, observability, security                                  | Platform uptime, cost efficiency                         |
| BI-аналитик      | 5                     | Self-service отчёты, дашборды, обучение            | % self-service, time-to-insight                          |
| Data Steward             | 3                     | Метаданные, compliance, доступ, документация | % данных с документацией, compliance |
| **Всего**     | **25**          |                                                                          |                                                          |

## Домены и bounded contexts

```mermaid
graph TB
    subgraph "Будущее 2.0"
        HO[Головной офис<br/>HR, Финансы, KPI]
        CL[Клиники<br/>Пациенты, Мед.карты, Визиты]
        AI[ИИ-сервисы<br/>Модели, Датасеты, Результаты]
        FT[Финтех / Банк<br/>Клиенты, Счета, Кредиты]
    end

    CL -- PatientRegistered --> FT
    CL -- VisitCompleted --> AI
    FT -- CreditApproved --> CL
    FT -- PaymentMade --> HO
    AI -- DiagnosisMade --> CL
    HO -- KPI_Report --> HO
```

## Этапы внедрения (Gantt)

```mermaid
gantt
    title Стратегический роадмап Data Mesh (2026-2029)
    dateFormat  YYYY-MM-DD
    axisFormat  %Y Q%q
    excludes    weekends

    section Ф0 Подготовка
    Домены и границы           :p0a, 2026-07-01, 30d
    Найм CDO                   :p0b, 2026-07-15, 45d
    MVP платформы              :p0c, 2026-08-01, 60d
    Обучение команды           :p0d, 2026-08-15, 45d

    section Ф1 Пилот
    Пилот FT+CL                :p1a, 2026-10-01, 90d
    Data-продукты              :p1b, 2026-10-15, 75d
    Self-service BI            :p1c, 2026-11-01, 60d
    Data Catalog               :p1d, 2026-11-15, 45d
    Веха Pilot Launch          :milestone, m1, 2027-01-01, 0d

    section Ф2 Масштаб
    ИИ-домен                   :p2a, 2027-04-01, 90d
    Streaming витрины          :p2b, 2027-04-15, 120d
    ACL для Camel              :p2c, 2027-05-01, 90d
    Governance                 :p2d, 2027-06-01, 60d
    Веха All Domains           :milestone, m2, 2027-10-01, 0d

    section Ф3 Оптимизация
    Data observability         :p3a, 2027-10-01, 90d
    Cost optimization          :p3b, 2027-10-15, 90d
    ML и Advanced analytics    :p3c, 2027-11-01, 90d
    Data marketplace           :p3d, 2027-12-01, 60d

    section Ф4 Зрелость
    Real-time 80 процентов     :p4a, 2028-04-01, 90d
    Self-service 90 процентов  :p4b, 2028-04-15, 90d
    Отказ от sync              :p4c, 2028-05-01, 90d
    Веха Full Maturity         :milestone, m3, 2028-10-01, 0d

    section Ф5 Монетизация
    Внешняя монетизация        :p5a, 2028-10-01, 180d
    Multi-region               :p5b, 2028-10-15, 180d
    Transfer pricing           :p5c, 2029-01-01, 90d
    Веха Monetization          :milestone, m4, 2029-06-01, 0d
```

## Привязка этапов к бизнес-целям

| **Фаза**                | **Срок** | **Бизнес-цель**                    | **Ключевые результаты**        | **KPI**                     |
| --------------------------------- | ------------------ | -------------------------------------------------- | ------------------------------------------------------ | --------------------------------- |
| 0. Подготовка           | 0–3 мес        | Фундамент                                 | 4 домена, MVP платформы, команда | 80% команды обучено |
| 1. Пилот                     | 3–6 мес        | Сокращение time-to-market                | 3–5 data-продуктов, 10+ дашбордов   | Time-to-market −50%              |
| 2. Масштабирование | 6–12 мес       | Масштабирование продуктов  | Все 4 домена на Data Mesh                   | 20+ data-продуктов       |
| 3. Оптимизация         | 12–18 мес      | Снижение TCO                               | Cost per product −30%                                 | TCO −30%                         |
| 4. Зрелость               | 18–24 мес      | Near-real-time                                     | 80% данных в real-time                          | Query latency <10 сек          |
| 5. Монетизация         | 24–36 мес      | Рост выручки, гео-экспансия | 100M+ ₽/год, 2–3 региона                   | Revenue from data                 |

## Целевая архитектура (C4-контейнеры)

```mermaid
graph TB
    subgraph "Self-Service Platform"
        SS[Портал самообслуживания<br/>Apache Superset]
        DC[Data Catalog<br/>DataHub]
        DBT[dbt Cloud]
    end

    subgraph "Data Mesh Домены"
        DP1[Data Product:<br/>Клиентский профиль<br/>FT / PostgreSQL + Kafka]
        DP2[Data Product:<br/>Визиты пациентов<br/>CL / ClickHouse + Kafka]
        DP3[Data Product:<br/>ИИ-модели<br/>AI / S3 + Kafka]
        DP4[Data Product:<br/>KPI отчётность<br/>HO / ClickHouse]
    end

    subgraph "Event Backbone"
        KF[Apache Kafka<br/>Event Bus + Schema Registry]
    end

    subgraph "Legacy Bridges (ACL)"
        ACL1[ACL: Camel → Kafka]
        ACL2[ACL: DWH → ClickHouse]
    end

    subgraph "Legacy (вывод)"
        SQL[(MS SQL Server 2008)]
        CML[Apache Camel ESB]
        PBI[Power BI]
    end

    SS --> DP1 & DP2 & DP3 & DP4
    DC --> DP1 & DP2 & DP3 & DP4
    DP1 & DP2 & DP3 & DP4 --> KF
    KF --> DP1 & DP2 & DP3 & DP4

    SQL --> ACL2 --> DP2
    CML --> ACL1 --> KF
    PBI -.->|замена| SS
```

## Governance-структура

```mermaid
graph TD
    SC[Steering Committee<br/>CDO, CTO, CFO, DPO<br/>Ежемесячно] --> AB[Architecture Board<br/>Lead Architect, Platform<br/>Bi-weekly]
    AB --> DQ[Data Quality Council<br/>Data Stewards, Engineers<br/>Еженедельно]
    SC --> DPO1[DPO: Головной офис]
    SC --> DPO2[DPO: Клиники]
    SC --> DPO3[DPO: ИИ-сервисы]
    SC --> DPO4[DPO: Финтех]
```

## Карта рисков

| **Риск**                              | **Вероятность** | **Влияние** | **Митигация**                   |
| ----------------------------------------------- | -------------------------------- | ------------------------ | ---------------------------------------------- |
| Сопротивление изменениям | Высокая                   | Высокое           | Change champions, quick wins, обучение |
| Нехватка Data Engineers                 | Высокая                   | Высокое           | Рынок +20%, обучение, outsourcing |
| Сложности миграции legacy      | Средняя                   | Высокое           | Phased approach, ACL, parallel run             |
| Превышение бюджета             | Средняя                   | Среднее           | Strict governance, cost monitoring             |
| Data quality проблемы                   | Средняя                   | Высокое           | DQ framework, автоматизация       |
| Compliance violations                           | Низкая                     | Критическое   | Federated governance, аудит               |
| Vendor lock-in                                  | Средняя                   | Среднее           | Open-source, multi-cloud                       |

## Бюджет по фазам

| **Фаза**                | **Длительность** | **Инвестиции** | **Команда** |
| --------------------------------- | ---------------------------------- | ------------------------------ | ------------------------ |
| 0. Подготовка           | 3 мес                           | 10M ₽                         | 7 чел                 |
| 1. Пилот                     | 3 мес                           | 15M ₽                         | 12 чел                |
| 2. Масштабирование | 6 мес                           | 25M ₽                         | 20 чел                |
| 3. Оптимизация         | 6 мес                           | 15M ₽                         | 22 чел                |
| 4. Зрелость               | 6 мес                           | 10M ₽                         | 25 чел                |
| 5. Монетизация         | 12 мес                          | 5M ₽                          | 25 чел                |
| **ИТОГО**              | **36 мес**                | **80M ₽**               | **25 чел**      |

## Ключевые выводы

```mermaid
graph LR
    A[TCO To-Be выше на 16%] --> B[Но выгоды в 4.9× больше]
    B --> C[ROI 390% за 3 года]
    C --> D[Окупаемость ~7 мес]
    D --> E[NPV +146.5 млн ₽]
    E --> F[Проект устойчив<br/>во всех сценариях]
```
