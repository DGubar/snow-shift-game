// =================================================================
// СНЕЖНАЯ ВАХТА: БАЗА ДАННЫХ ИГРЫ (ПЕРЕМЕННЫЕ)
// Шаг 1: Определение всех состояний и счетчиков
// =================================================================

// -----------------------------------------------------------------
// 1. ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ИГРЫ
// -----------------------------------------------------------------
VAR turns_until_rescue = 12   // Сколько всего ходов нужно продержаться
VAR current_turn = 1          // Текущий ход
VAR game_over = false         // Флаг для завершения игрового цикла (true = игра окончена)
VAR game_result = ""          // Сюда запишем результат: "поражение", "1_звезда", "2_звезды", "3_звезды"


// -----------------------------------------------------------------
// 2. ПЕРЕМЕННЫЕ ЗОН (всего 9 зон)
// -----------------------------------------------------------------
VAR zone_1_accessible = false  // Станция Зарядки
VAR zone_2_accessible = true   // Дом Воскобойниковых (стартовая зона)
VAR zone_3_accessible = false  // Клуб
VAR zone_4_accessible = false  // Теплица
VAR zone_5_accessible = false  // Медпункт
VAR zone_6_accessible = false  // Склад
VAR zone_7_accessible = true   // Дом Следопытовых (стартовая зона)
VAR zone_8_accessible = false  // Теплостанция
VAR zone_9_accessible = true   // Дом Гладковых (стартовая зона)

// -----------------------------------------------------------------
// 3. ПЕРЕМЕННЫЕ СОСТОЯНИЯ ОБЪЕКТОВ И ЛОКАЦИЙ
// -----------------------------------------------------------------
// Состояния: "ok", "broken"
VAR heat_station_status = "broken"      // Теплостанция (8)
VAR heat_station_broken_turns = 0     // Счетчик ходов поломки теплостанции (начинаем с 0)
VAR med_point_status = "broken"         // Медпункт (5)
VAR greenhouse_status = "broken"        // Теплица (4)


// -----------------------------------------------------------------
// 4. ПЕРЕМЕННЫЕ СОСТОЯНИЯ МАЛЫШЕЙ (РАСШИРЕННЫЙ БЛОК)
// -----------------------------------------------------------------
// Состояние АКТИВНОСТИ малышей ("busy", "useful", "naughty")
VAR andreyka_activity = "busy"
VAR sonya_tonya_activity = "busy"
VAR kirillka_activity = "busy"

// Состояние ЗДОРОВЬЯ Сони и Тони
VAR sonya_tonya_health_status = "healthy"
VAR sonya_tonya_injured_turns = 0

// НОВОЕ: МЕСТОПОЛОЖЕНИЕ МАЛЫШЕЙ
// "home", "club", "greenhouse"
VAR andreyka_location = "home"
VAR sonya_tonya_location = "home"
VAR kirillka_location = "home"

// НОВОЕ: ФЛАГИ ДЛЯ ДИАЛОГОВ И МЕХАНИК
VAR kirillka_hijack_event_triggered = false // Это у вас уже было
VAR kirillka_hijack_dialogue_seen = false   // И это тоже

VAR club_unlocked_dialogue_seen = false     // Видел ли игрок диалог про открытие Клуба?
VAR kirillka_bored_dialogue_seen = false    // Видел ли игрок диалог про скучающего Кирилку?
VAR kirillka_greenhouse_option_unlocked = false // Разблокирована ли опция "Отправить в Теплицу"?

// -----------------------------------------------------------------
// 5. ПЕРЕМЕННЫЕ ПОДРОСТКОВ (ЛОКАЦИЯ И ИНВЕНТАРЬ)
// -----------------------------------------------------------------
// Местоположение персонажей
VAR nadya_location = 7      // Надя начинает в доме Следопытовых
VAR artem_location = 2      // Артем - в доме Воскобойниковых
VAR ignat_location = 9      // Игнат - в доме Гладковых
VAR masha_location = 9      // Маша - в доме Гладковых

// -----------------------------------------------------------------
// 6. ПЕРЕМЕННЫЕ ШНЕКОРОТОРОВ
// -----------------------------------------------------------------
// Состояния: "charged" (заряжен), "discharged" (разряжен, нужен ход на зарядку), "broken" (сломан)
VAR shnekorotor_A_status = "charged" // База: 7
VAR shnekorotor_B_status = "charged" // База: 2
VAR shnekorotor_C_status = "charged" // База: 9

// -----------------------------------------------------------------
// 7. ПЕРЕМЕННЫЕ ДРОНОВ
// -----------------------------------------------------------------
// Состояния:
// "broken" - сломан.
// "ok"     - готов и функционирует.
// Ремонт происходит в один ход при одновременном выполнении двух условий:
// 1. В локации есть запчасть (переменные parts_at_club / parts_at_greenhouse).
// 2. Назначен компетентный исполнитель (переменные *_task).
VAR club_drone_status = "broken"
VAR greenhouse_drone_status = "broken"

// -----------------------------------------------------------------
// 8. ПЕРЕМЕННЫЕ РЕСУРСОВ (ЗАПЧАСТИ)
// -----------------------------------------------------------------
VAR parts_at_warehouse = 10  // Сколько всего запчастей на складе (6)
// Запчасти, доставленные на место для ремонта
VAR parts_at_club = 0 // Локация 3
VAR parts_at_greenhouse = 0 // Локация 4
VAR parts_at_heat_station = 0 // Локация 8
VAR parts_at_med_point = 0    // Локация 5

// -----------------------------------------------------------------
// 9. ВРЕМЕННЫЕ ПЕРЕМЕННЫЕ ДЛЯ НАЗНАЧЕНИЯ ЗАДАЧ (сбрасываются каждый ход)
// -----------------------------------------------------------------
// Сюда мы будем записывать, какое задание было дано юниту в текущем ходу
VAR nadya_task = "none"
VAR artem_task = "none"
VAR ignat_task = "none"
VAR masha_task = "none"

VAR shnekorotor_A_task = "none"
VAR shnekorotor_B_task = "none"
VAR shnekorotor_C_task = "none"


// =================================================================
// ЗДЕСЬ НАЧНЕТСЯ ОСНОВНАЯ ЛОГИКА ИГРЫ
// =================================================================
-> intro_1
// =================================================================
// СНЕЖНАЯ ВАХТА: ОСНОВНОЙ ИГРОВОЙ ЦИКЛ
// Шаг 2: Создание структуры для управления ходом игры
// =================================================================

// === main_game_loop ===
// Этот узел (knot) - сердце игры. Он запускается в начале каждого хода.
=== main_game_loop ===
// --- ПРОВЕРКА СОБЫТИЙ В НАЧАЛЕ ХОДА ---
// НОВОЕ: Проверка диалога об открытии Клуба
{ zone_3_accessible and not club_unlocked_dialogue_seen:
    -> club_unlock_dialogue
}
// НОВОЕ: Проверка диалога о скучающем Кирилке
// Условие: Кирилка в клубе, путь до Теплицы (4) от его дома (9) открыт, и диалог не видели
{ kirillka_location == "club" and zone_8_accessible and zone_5_accessible and zone_4_accessible and not kirillka_bored_dialogue_seen:
    -> kirillka_bored_dialogue
}
// Старый диалог про угон
{ kirillka_hijack_event_triggered and not kirillka_hijack_dialogue_seen:
    -> kirillka_hijack_dialogue 
}

// Первым делом мы проверяем, не закончилась ли игра.
// 1. Счетчик ходов исчерпан (победа).
{ turns_until_rescue < current_turn:
    ~ game_over = true
    ~ game_result = "1_звезда" // По умолчанию победа на 1 звезду
    -> game_over_knot
}
// 2. Флаг game_over был установлен из-за проигрыша.
{ game_over:
    -> game_over_knot
}

// Если игра продолжается, мы переходим к фазе отчета.
-> upkeep_phase


// === upkeep_phase ===
// Эта фаза происходит в самом начале хода, ДО отчета.
// Здесь происходят все автоматические события "на рассвете".
=== upkeep_phase ===
    // --- АВТОМАТИЧЕСКАЯ ЗАРЯДКА ШНЕКОРОТОРОВ ---
    // Здесь мы проверяем состояние зон, которое было установлено в КОНЦЕ прошлого хода.
    
    { shnekorotor_A_status == "discharged" and zone_4_accessible and zone_1_accessible:
        ~ shnekorotor_A_status = "charged"
    }
    { shnekorotor_B_status == "discharged" and zone_1_accessible:
        ~ shnekorotor_B_status = "charged"
    }
    { shnekorotor_C_status == "discharged" and zone_1_accessible and ( (zone_8_accessible and zone_5_accessible and zone_2_accessible) or (zone_6_accessible and zone_5_accessible and zone_2_accessible) or (zone_6_accessible and zone_3_accessible and zone_2_accessible) ) :
        ~ shnekorotor_C_status = "charged"
    }
    
    // После выполнения всех утренних дел, переходим к отчету.
    -> report_phase
    
=== report_phase ===
# clear

// ОДИН-ЕДИНСТВЕННЫЙ ВЫБОР, который показывает ВЕСЬ текст отчета.
+ **[Час {current_turn} из {turns_until_rescue} до прибытия помощи. Получить сводку.]**

    // Ниже идет ПРОСТО ТЕКСТ. Символы '--' и '---' используются для красоты.
    -- Состояние систем:
    --- Теплостанция: {heat_station_status}. {heat_station_broken_turns} ходов сломана.
    --- Медпункт: {med_point_status}.
    -- Состояние Зон Доступа:
    --- Наша общая зона контроля включает локации:
    {zone_1_accessible: 1 (Станция Зарядки) |}
    {zone_2_accessible: 2 (Дом Воскобойниковых) |}
    {zone_3_accessible: 3 (Клуб) |}
    {zone_4_accessible: 4 (Теплица) |}
    {zone_5_accessible: 5 (Медпункт) |}
    {zone_6_accessible: 6 (Склад) |}
    {zone_7_accessible: 7 (Дом Следопытовых) |}
    {zone_8_accessible: 8 (Теплостанция) |}
    {zone_9_accessible: 9 (Дом Гладковых) |}

    --- Стратегическая сводка:
    ---- Доступ к Складу (6): {zone_6_accessible: Есть | НЕТ}
    ---- Доступ к Станции Зарядки (1): {zone_1_accessible: Есть | НЕТ}
    ---- Доступ к Теплостанции (8): {zone_8_accessible: Есть | НЕТ}
    ---- Доступ к Медпункту (5): {zone_5_accessible: Есть | НЕТ}
    
    -- Статус малышей:
    --- Соня и Тоня: {sonya_tonya_health_status}.

    -- Ресурсы:
    --- Запчастей на складе: {parts_at_warehouse}.

    // После того, как ВЕСЬ текст показан, игра ГАРАНТИРОВАННО переходит дальше.
    -> reset_phase


=== reset_phase ===
    ~ nadya_task = "none"
    ~ artem_task = "none"
    ~ ignat_task = "none"
    ~ masha_task = "none"
    ~ shnekorotor_A_task = "none"
    ~ shnekorotor_B_task = "none"
    ~ shnekorotor_C_task = "none"
-> assignment_phase
    
// === assignment_phase ===
// Этот узел теперь - просто контейнер для цикла назначения.
=== assignment_phase ===

// Это "якорь" (stitch), к которому мы будем возвращаться.
= assignment_loop
    # clear
    Задачи на этот час:
    - Надя Следопытова: {nadya_task}
    - Артем Воскобойников: {artem_task}
    - Игнат Гладков: {ignat_task}
    - Маша Гладкова: {masha_task}
    - Шнекоротор А (База 7): {shnekorotor_A_task}
    - Шнекоротор B (База 2): {shnekorotor_B_task}
    - Шнекоротор C (База 9): {shnekorotor_C_task}
    
    // Этот gather (дефис) "перезагружает" список выборов при каждом заходе
    -
    + {nadya_task == "none"} [Назначить задачу Надежде] -> assign_nadya
    + {artem_task == "none"} [Назначить задачу Артему] -> assign_artem
    + {ignat_task == "none"} [Назначить задачу Игнату] -> assign_ignat
    + {masha_task == "none"} [Назначить задачу Маше] -> assign_masha
    
    + {shnekorotor_A_status == "charged" and shnekorotor_A_task == "none"} [Назначить задачу Шнекоротору А] -> assign_shnek_A
    + {shnekorotor_B_status == "charged" and shnekorotor_B_task == "none"} [Назначить задачу Шнекоротору B] -> assign_shnek_B
    + {shnekorotor_C_status == "charged" and shnekorotor_C_task == "none"} [Назначить задачу Шнекоротору C] -> assign_shnek_C
    
    + [Все задачи распределены, начать выполнение] -> resolution_phase

// --- Узлы (Stitches) для назначения задач каждому юниту ---
// ВАЖНО: Теперь они все должны возвращать нас на "якорь" assignment_loop
= assign_nadya
    // Для доставки нужны и Склад (6), и сама цель
    + {zone_6_accessible and zone_8_accessible} [Доставить запчасть на Теплостанцию (8)]
        ~ nadya_task = "deliver_part_to_8"
        -> assignment_loop
    + {zone_6_accessible and zone_5_accessible} [Доставить запчасть в Медпункт (5)]
        ~ nadya_task = "deliver_part_to_5"
        -> assignment_loop
    + {zone_6_accessible and zone_4_accessible} [Доставить запчасть в Теплицу (4)]
        ~ nadya_task = "deliver_part_to_4"
        -> assignment_loop
    + {zone_6_accessible and zone_3_accessible} [Доставить запчасть в Клуб (3)]
        ~ nadya_task = "deliver_part_to_3"
        -> assignment_loop
    + [Присмотреть за Андрейкой (в доме 7)]
        ~ nadya_task = "babysit_andreyka"
        -> assignment_loop
  // НОВАЯ ЗАДАЧА: Отвести "своего" малыша в Клуб
    + { andreyka_location == "home" and zone_8_accessible and zone_6_accessible and zone_3_accessible }: [Отвести Андрейку в Клуб (3)]
        ~ nadya_task = "escort_andreyka_to_club"
        -> assignment_loop
    + [Отмена] -> assignment_loop

= assign_artem
    + {zone_5_accessible} [Лечить в Медпункте (5)]
        ~ artem_task = "heal"
        -> assignment_loop
    + {zone_6_accessible and zone_8_accessible} [Доставить запчасть на Теплостанцию (8)]
        ~ artem_task = "deliver_part_to_8"
        -> assignment_loop
    + {zone_6_accessible and zone_5_accessible} [Доставить запчасть в Медпункт (5)]
        ~ artem_task = "deliver_part_to_5"
        -> assignment_loop
    + {zone_6_accessible and zone_4_accessible} [Доставить запчасть в Теплицу (4)]
        ~ artem_task = "deliver_part_to_4"
        -> assignment_loop
    + {zone_6_accessible and zone_3_accessible} [Доставить запчасть в Клуб (3)]
        ~ artem_task = "deliver_part_to_3"
        -> assignment_loop
    + [Присмотреть за Соней и Тоней (в доме 2)]
        ~ artem_task = "babysit_sonya_tonya"
        -> assignment_loop
    + { sonya_tonya_location == "home" and zone_3_accessible }: [Отвести Соню и Тоню в Клуб (3)]
        ~ artem_task = "escort_sonya_tonya_to_club"
        -> assignment_loop
    + { kirillka_greenhouse_option_unlocked and kirillka_location != "greenhouse" and ( (zone_4_accessible and zone_5_accessible and zone_6_accessible) or (zone_4_accessible and zone_8_accessible) or (zone_1_accessible and zone_6_accessible) ) }: [Отправить Кирилку в Теплицу (4)]
    ~ artem_task = "escort_kirillka_to_greenhouse"
        -> assignment_loop
    + [Отмена] -> assignment_loop
    
= assign_ignat
    // Починка основных объектов требует доступа к их зонам
    + {zone_8_accessible} [Чинить Теплостанцию (8)]
        ~ ignat_task = "fix_heat_station"
        -> assignment_loop
    + {zone_5_accessible} [Чинить Медпункт (5)]
        ~ ignat_task = "fix_med_point"
        -> assignment_loop
    + {zone_4_accessible} [Починить тепличного дрона (в теплице 4)]
        ~ ignat_task = "fix_greenhouse_drone"
        -> assignment_loop
        
    // Починка шнекороторов требует доступа к их базам
    + {shnekorotor_A_status == "broken" and zone_7_accessible} [Починить Шнекоротор А (на базе 7)]
        ~ ignat_task = "fix_shnek_A"
        -> assignment_loop
    + {shnekorotor_B_status == "broken" and zone_2_accessible} [Починить Шнекоротор B (на базе 2)]
        ~ ignat_task = "fix_shnek_B"
        -> assignment_loop
    + {shnekorotor_C_status == "broken" and zone_9_accessible} [Починить Шнекоротор C (на базе 9)]
        ~ ignat_task = "fix_shnek_C"
        -> assignment_loop
    + [Присмотреть за Кирилкой (в доме 9)]
        ~ ignat_task = "babysit_kirillka"
        -> assignment_loop
        // НОВАЯ ЗАДАЧА: Отвести "своего" малыша в Клуб
    + { kirillka_location == "home" and zone_3_accessible and zone_6_accessible }: [Отвести Кирилку в Клуб (3)]
        ~ ignat_task = "escort_kirillka_to_club"
        -> assignment_loop
    + [Отмена] -> assignment_loop

// Узел для Маши будет ИДЕНТИЧНЫМ, просто замените "ignat" на "masha"
= assign_masha
    // Починка основных объектов требует доступа к их зонам
    + {zone_8_accessible} [Чинить Теплостанцию (8)]
        ~ masha_task = "fix_heat_station"
        -> assignment_loop
    + {zone_5_accessible} [Чинить Медпункт (5)]
        ~ masha_task = "fix_med_point"
        -> assignment_loop
    + {zone_4_accessible} [Починить тепличного дрона (в теплице 4)]
        ~ masha_task = "fix_greenhouse_drone"
        -> assignment_loop
        
    // Починка шнекороторов требует доступа к их базам
    + {shnekorotor_A_status == "broken" and zone_7_accessible} [Починить Шнекоротор А (на базе 7)]
        ~ masha_task = "fix_shnek_A"
        -> assignment_loop
    + {shnekorotor_B_status == "broken" and zone_2_accessible} [Починить Шнекоротор B (на базе 2)]
        ~ masha_task = "fix_shnek_B"
        -> assignment_loop
    + {shnekorotor_C_status == "broken" and zone_9_accessible} [Починить Шнекоротор C (на базе 9)]
        ~ masha_task = "fix_shnek_C"
        -> assignment_loop
    + [Присмотреть за Кирилкой (в доме 9)]
        ~ masha_task = "babysit_kirillka"
        -> assignment_loop
    + { kirillka_location == "home" and zone_3_accessible and zone_6_accessible }: [Отвести Кирилку в Клуб (3)]
        ~ masha_task = "escort_kirillka_to_club"
        -> assignment_loop
    + [Отмена] -> assignment_loop
    
= assign_shnek_A // База 7. Ответственность: северный и центральный регионы.
    
    // --- Задачи с его родной базы (7) ---
    + {zone_7_accessible and not zone_4_accessible} [Расширить доступ от Дома (7) к Теплице (4)] -> expand_zone("A", 7, 4)
    + {zone_7_accessible and not zone_8_accessible} [Расширить доступ от Дома (7) к Теплостанции (8)] -> expand_zone("A", 7, 8)

    // --- Задачи с новой границы: Теплица (4) ---
    // Эти кнопки появятся, только когда зона 4 станет доступной.
    + {zone_4_accessible and not zone_1_accessible} [Расширить доступ от Теплицы (4) к Станции Зарядки (1)] -> expand_zone("A", 4, 1)
    + {zone_4_accessible and not zone_5_accessible} [Расширить доступ от Теплицы (4) к Медпункту (5)] -> expand_zone("A", 4, 5)

    // --- Задачи с новой границы: Теплостанция (8) ---
    // Эти кнопки появятся, только когда зона 8 станет доступной.
    + {zone_8_accessible and not zone_5_accessible} [Расширить доступ от Теплостанции (8) к Медпункту (5)] -> expand_zone("A", 8, 5)
    + {zone_8_accessible and not zone_9_accessible} [Расширить доступ от Теплостанции (8) к Дому Гладковых (9)] -> expand_zone("A", 8, 9)
    + [Отмена] -> assignment_loop

= assign_shnek_B // База 2
    // --- Задачи с его родной базы (2) ---
    + {zone_2_accessible and not zone_1_accessible} [Расширить доступ от Дома (2) к Станции Зарядки (1)] -> expand_zone("B", 2, 1)
    + {zone_2_accessible and not zone_3_accessible} [Расширить доступ от Дома (2) к Клубу (3)] -> expand_zone("B", 2, 3)
    + {zone_2_accessible and not zone_5_accessible} [Расширить доступ от Дома (2) к Медпункту (5)] -> expand_zone("B", 2, 5)

    // --- Задачи с новой границы: Станция зарядки (1) ---
    // Эти кнопки появятся, ТОЛЬКО КОГДА зона 1 станет доступной
    + {zone_1_accessible and not zone_4_accessible} [Расширить доступ от Станции зарядки (1) к Теплице (4)] -> expand_zone("B", 1, 4)
    
    // --- Задачи с новой границы: Медпункт (5) ---
    // Эти кнопки появятся, ТОЛЬКО КОГДА зона 5 станет доступной
    + {zone_5_accessible and not zone_4_accessible} [Расширить доступ от Медпункта (5) к Теплице (4)] -> expand_zone("B", 5, 4)
    + {zone_5_accessible and not zone_6_accessible} [Расширить доступ от Медпункта (5) к Складу (6)] -> expand_zone("B", 5, 6)
    + {zone_5_accessible and not zone_8_accessible} [Расширить доступ от Медпункта (5) к Теплостанции (8)] -> expand_zone("B", 5, 8)

    // --- Задачи с новой границы: Клуб (3) ---
    + {zone_3_accessible and not zone_6_accessible} [Расширить доступ от Клуба (3) к Складу (6)] -> expand_zone("B", 3, 6)
    + [Отмена] -> assignment_loop

= assign_shnek_C // База 9. Ответственность: южный и восточный регионы.
    // --- Задачи с его родной базы (9) ---
    + {zone_9_accessible and not zone_6_accessible} [Расширить доступ от Дома (9) к Складу (6)] -> expand_zone("C", 9, 6)
    + {zone_9_accessible and not zone_8_accessible} [Расширить доступ от Дома (9) к Теплостанции (8)] -> expand_zone("C", 9, 8)

    // --- Задачи с новой границы: Склад (6) ---
    // Эти кнопки появятся, только когда зона 6 станет доступной.
    + {zone_6_accessible and not zone_3_accessible} [Расширить доступ от Склада (6) к Клубу (3)] -> expand_zone("C", 6, 3)
    + {zone_6_accessible and not zone_5_accessible} [Расширить доступ от Склада (6) к Медпункту (5)] -> expand_zone("C", 6, 5)

    // --- Задачи с новой границы: Теплостанция (8) ---
    // Эти кнопки появятся, только когда зона 8 станет доступной.
    + {zone_8_accessible and not zone_5_accessible} [Расширить доступ от Теплостанции (8) к Медпункту (5)] -> expand_zone("C", 8, 5)
    + {zone_8_accessible and not zone_7_accessible} [Расширить доступ от Теплостанции (8) к Дому Следопытовых (7)] -> expand_zone("C", 8, 7)
    + [Отмена] -> assignment_loop

// === УЗЕЛ-ПОМОЩНИК ДЛЯ НАЗНАЧЕНИЯ ЗАДАЧИ РАСШИРЕНИЯ ===
// Он просто назначает задачу, чтобы не дублировать код

= expand_zone(shnek, from, to)
    { shnek == "A": 
        ~ shnekorotor_A_task = "expand_{from}_to_{to}" 
    }
    { shnek == "B": 
        ~ shnekorotor_B_task = "expand_{from}_to_{to}" 
    }
    { shnek == "C": 
        ~ shnekorotor_C_task = "expand_{from}_to_{to}" 
    }
    -> assignment_loop


// === resolution_phase ===
// Эта комната теперь АВТОМАТИЧЕСКИ запускает всю цепочку событий.
=== resolution_phase ===

    // ШАГ 1: Обновляем счетчики бедствий в НАЧАЛЕ фазы
    { heat_station_status == "broken":
        ~ heat_station_broken_turns = heat_station_broken_turns + 1
    }
    { sonya_tonya_health_status == "injured":
        ~ sonya_tonya_injured_turns = sonya_tonya_injured_turns + 1
    }

    // ШАГ 2: Запускаем ПЕРВЫЙ узел в цепочке - логику малышей.
    -> malyshi_ai_phase
  
// Это "якорь" или "закладка". Сюда игра вернется в самом конце,
// чтобы завершить ход.  
    = final_checks
    // ШАГ 3: Проверяем условия проигрыша в КОНЦЕ фазы
    { heat_station_broken_turns >= 3:
        ~ game_over = true
        ~ game_result = "поражение_холод"
    }
    { sonya_tonya_injured_turns >= 3:
        ~ game_over = true
        ~ game_result = "поражение_травма"
    }

    // ШАГ 4: Переходим к следующему ходу (если игра не окончена)
    ~ current_turn = current_turn + 1
    -> main_game_loop
    
// === malyshi_ai_phase ===
// Это ОТДЕЛЬНАЯ, скрытая комната для логики малышей.
=== malyshi_ai_phase ===

// =================================================================
// СЕКЦИЯ 1: ОПРЕДЕЛЕНИЕ СОСТОЯНИЯ КАЖДОГО МАЛЫША
// =================================================================

// --- Логика для Андрейки ---
{ andreyka_location == "club":
    { club_drone_status == "broken" and parts_at_club > 0:
        ~ andreyka_activity = "useful"
    - else:
        ~ andreyka_activity = "busy"
    }
- else:
    { nadya_task == "babysit_andreyka":
        ~ andreyka_activity = "busy"
    - else:
        ~ andreyka_activity = "naughty"
    }
}

// --- Логика для Сони и Тони ---
{ sonya_tonya_location == "club":
    { club_drone_status == "broken" and parts_at_club > 0:
        ~ sonya_tonya_activity = "useful"
    - else:
        ~ sonya_tonya_activity = "busy"
    }
- else:
    { artem_task == "babysit_sonya_tonya":
        ~ sonya_tonya_activity = "busy"
    - else:
        ~ sonya_tonya_activity = "naughty"
    }
}

// --- Логика для Кирилки ---
{ kirillka_location == "club":
    { club_drone_status == "broken" and parts_at_club > 0:
        ~ kirillka_activity = "useful"
    - else:
        ~ kirillka_activity = "busy"
    }
}
{ kirillka_location == "greenhouse":
    { greenhouse_drone_status == "broken" and parts_at_greenhouse > 0:
        ~ kirillka_activity = "useful"
    - else:
        ~ kirillka_activity = "busy"
    }
}
{ kirillka_location == "home":
    { ignat_task == "babysit_kirillka" or masha_task == "babysit_kirillka":
        ~ kirillka_activity = "busy"
    - else:
        ~ kirillka_activity = "naughty"
    }
}

// =================================================================
// СЕКЦИЯ 2: ВЫПОЛНЕНИЕ ДЕЙСТВИЙ ПО РЕЗУЛЬТАТАМ
// =================================================================

// --- "Полезные" действия ---
{ (andreyka_activity == "useful" or sonya_tonya_activity == "useful" or (kirillka_activity == "useful" and kirillka_location == "club")) and club_drone_status == "broken":
    ~ club_drone_status = "ok"
    ~ parts_at_club = 0
}

{ kirillka_activity == "useful" and kirillka_location == "greenhouse" and greenhouse_drone_status == "broken":
    ~ greenhouse_drone_status = "ok"
    ~ parts_at_greenhouse = 0
}

// --- "Шаловливые" действия ---

// Логика Андрейки (ломает ОДНУ вещь за ход)
{ andreyka_activity == "naughty":
    { shnekorotor_A_status == "charged":
        ~ shnekorotor_A_status = "broken"
    - else:
        { shnekorotor_B_status == "charged":
            ~ shnekorotor_B_status = "broken"
        - else:
            { shnekorotor_C_status == "charged":
                ~ shnekorotor_C_status = "broken"
            }
        }
    }
}

// Логика Сони и Тони
{ sonya_tonya_activity == "naughty" and sonya_tonya_health_status == "healthy":
    ~ sonya_tonya_health_status = "injured"
}

// Логика Кирилки (используем вашу отлаженную логику угона)
{ kirillka_activity == "naughty":
    // --- ПРИОРИТЕТ 1: Открыть путь 9 -> 8 ---
    { not zone_8_accessible:
        { shnekorotor_C_status == "charged":
            ~ zone_8_accessible = true
            ~ shnekorotor_C_status = "discharged"
            ~ kirillka_hijack_event_triggered = true
        - else:
            { shnekorotor_B_status == "charged":
                ~ zone_8_accessible = true
                ~ shnekorotor_B_status = "discharged"
                ~ kirillka_hijack_event_triggered = true
            - else:
                { shnekorotor_A_status == "charged":
                    ~ zone_8_accessible = true
                    ~ shnekorotor_A_status = "discharged"
                    ~ kirillka_hijack_event_triggered = true
                }
            }
        }
    - else:
        // --- ПРИОРИТЕТ 2: Если 9->8 открыт, открываем 9 -> 6 ---
        { not zone_6_accessible:
            { shnekorotor_C_status == "charged":
                ~ zone_6_accessible = true
                ~ shnekorotor_C_status = "discharged"
                ~ kirillka_hijack_event_triggered = true
            - else:
                { shnekorotor_B_status == "charged":
                    ~ zone_6_accessible = true
                    ~ shnekorotor_B_status = "discharged"
                    ~ kirillka_hijack_event_triggered = true
                - else:
                    { shnekorotor_A_status == "charged":
                        ~ zone_6_accessible = true
                        ~ shnekorotor_A_status = "discharged"
                        ~ kirillka_hijack_event_triggered = true
                    }
                }
            }
        - else:
            // --- ПРИОРИТЕТ 3: Если и те открыты, открываем 6 -> 5 ---
            { not zone_5_accessible:
                 { shnekorotor_C_status == "charged":
                    ~ zone_5_accessible = true
                    ~ shnekorotor_C_status = "discharged"
                    ~ kirillka_hijack_event_triggered = true
                - else:
                    { shnekorotor_B_status == "charged":
                        ~ zone_5_accessible = true
                        ~ shnekorotor_B_status = "discharged"
                        ~ kirillka_hijack_event_triggered = true
                    - else:
                        { shnekorotor_A_status == "charged":
                            ~ zone_5_accessible = true
                            ~ shnekorotor_A_status = "discharged"
                            ~ kirillka_hijack_event_triggered = true
                        }
                    }
                }
            }
        }
    }
}

-> player_actions_phase
// Здесь обрабатываются ВСЕ ДЕЙСТВИЯ, назначенные игроком.
=== player_actions_phase ===
    // --- ОБРАБОТКА ДЕЙСТВИЙ ПОДРОСТКОВ ---

    // === ЗАДАЧИ НАДИ ===
{ nadya_task == "deliver_part_to_8" and parts_at_warehouse > 0:
    ~ parts_at_warehouse = parts_at_warehouse - 1
    ~ parts_at_heat_station = parts_at_heat_station + 1
    ~ nadya_location = 8
}
{ nadya_task == "deliver_part_to_5" and parts_at_warehouse > 0:
    ~ parts_at_warehouse = parts_at_warehouse - 1
    ~ parts_at_med_point = parts_at_med_point + 1
    ~ nadya_location = 5
}
{ nadya_task == "deliver_part_to_4" and parts_at_warehouse > 0:
    ~ parts_at_warehouse = parts_at_warehouse - 1
    ~ parts_at_greenhouse = parts_at_greenhouse + 1
    ~ nadya_location = 4
}
{ nadya_task == "deliver_part_to_3" and parts_at_warehouse > 0:
    ~ parts_at_warehouse = parts_at_warehouse - 1
    ~ parts_at_club = parts_at_club + 1
    ~ nadya_location = 3
}
{ nadya_task == "babysit_andreyka":
    // Действие присмотра выполнено. Его эффект учтен в malyshi_ai_phase.
    ~ nadya_location = 7
}
// НОВЫЙ БЛОК ДЛЯ СОПРОВОЖДЕНИЯ
{ nadya_task == "escort_andreyka_to_club":
    ~ andreyka_location = "club"  // Меняем местоположение малыша
    ~ nadya_location = 3          // Перемещаем Надю в Клуб на этот ход
}

// === ЗАДАЧИ АРТЕМА ===
{ artem_task == "heal" and med_point_status == "ok" and sonya_tonya_health_status == "injured":
    ~ sonya_tonya_health_status = "healthy"
    ~ sonya_tonya_injured_turns = 0
    ~ artem_location = 5
}
{ artem_task == "deliver_part_to_8" and parts_at_warehouse > 0:
    ~ parts_at_warehouse = parts_at_warehouse - 1
    ~ parts_at_heat_station = parts_at_heat_station + 1
    ~ artem_location = 8
}
{ artem_task == "deliver_part_to_5" and parts_at_warehouse > 0:
    ~ parts_at_warehouse = parts_at_warehouse - 1
    ~ parts_at_med_point = parts_at_med_point + 1
    ~ artem_location = 5
}
{ artem_task == "deliver_part_to_4" and parts_at_warehouse > 0:
    ~ parts_at_warehouse = parts_at_warehouse - 1
    ~ parts_at_greenhouse = parts_at_greenhouse + 1
    ~ artem_location = 4
}
{ artem_task == "deliver_part_to_3" and parts_at_warehouse > 0:
    ~ parts_at_warehouse = parts_at_warehouse - 1
    ~ parts_at_club = parts_at_club + 1
    ~ artem_location = 3
}
{ artem_task == "babysit_sonya_tonya":
    ~ artem_location = 2
}
{ artem_task == "escort_sonya_tonya_to_club":
    ~ sonya_tonya_location = "club" // Меняем местоположение малышей
    ~ artem_location = 3            // Перемещаем Артема в Клуб на этот ход
}

// НОВЫЙ БЛОК ДЛЯ СОПРОВОЖДЕНИЯ КИРИЛКИ
    { artem_task == "escort_kirillka_to_greenhouse":
    ~ kirillka_location = "greenhouse" // Меняем местоположение малыша
    ~ artem_location = 4               // Перемещаем Артема в Теплицу на этот ход
    }

// === ЗАДАЧИ ИГНАТА И МАШИ ===
// Улучшенная структура: один блок на каждое возможное действие.

// --- Починка Теплостанции (8) ---
{ (ignat_task == "fix_heat_station" or masha_task == "fix_heat_station") and heat_station_status == "broken" and parts_at_heat_station > 0:
    // Общая логика
    ~ heat_station_status = "ok"
    ~ heat_station_broken_turns = 0
    ~ parts_at_heat_station = parts_at_heat_station - 1
    
    // Уникальная логика с ПРАВИЛЬНЫМ синтаксисом
    { ignat_task == "fix_heat_station":
        ~ ignat_location = 8
    }
    { masha_task == "fix_heat_station":
        ~ masha_location = 8
    }
}

// --- Починка Медпункта (5) ---
{ (ignat_task == "fix_med_point" or masha_task == "fix_med_point") and med_point_status == "broken" and parts_at_med_point > 0:
    // Общая логика
    ~ med_point_status = "ok"
    ~ parts_at_med_point = parts_at_med_point - 1
    
    // Уникальная логика
    { ignat_task == "fix_med_point":
        ~ ignat_location = 5
    }
    { masha_task == "fix_med_point":
        ~ masha_location = 5
    }
}

// --- Починка Шнекоротора А (База 7) ---
{ (ignat_task == "fix_shnek_A" or masha_task == "fix_shnek_A") and shnekorotor_A_status == "broken":
    ~ shnekorotor_A_status = "discharged"
    { ignat_task == "fix_shnek_A":
        ~ ignat_location = 7
    }
    { masha_task == "fix_shnek_A":
        ~ masha_location = 7
    }
}

// --- Починка Шнекоротора B (База 2) ---
{ (ignat_task == "fix_shnek_B" or masha_task == "fix_shnek_B") and shnekorotor_B_status == "broken":
    ~ shnekorotor_B_status = "discharged"
    { ignat_task == "fix_shnek_B":
        ~ ignat_location = 2
    }
    { masha_task == "fix_shnek_B":
        ~ masha_location = 2
    }
}

// --- Починка Шнекоротора C (База 9) ---
{ (ignat_task == "fix_shnek_C" or masha_task == "fix_shnek_C") and shnekorotor_C_status == "broken":
    ~ shnekorotor_C_status = "discharged"
    { ignat_task == "fix_shnek_C":
        ~ ignat_location = 9
    }
    { masha_task == "fix_shnek_C":
        ~ masha_location = 9
    }
}

// --- Присмотр за Кирилкой (в доме 9) ---
{ ignat_task == "babysit_kirillka" or masha_task == "babysit_kirillka":
    { ignat_task == "babysit_kirillka":
        ~ ignat_location = 9
    }
    { masha_task == "babysit_kirillka":
        ~ masha_location = 9
    }
}

// --- Сопровождение Кирилки в Клуб (3) ---
{ ignat_task == "escort_kirillka_to_club" or masha_task == "escort_kirillka_to_club":
    ~ kirillka_location = "club"
    { ignat_task == "escort_kirillka_to_club":
        ~ ignat_location = 3
    }
    { masha_task == "escort_kirillka_to_club":
        ~ masha_location = 3
    }
}

// === ОБРАБОТКА ДЕЙСТВИЙ ШНЕКОРОТОРОВ (РАБОЧАЯ ВЕРСИЯ) ===
// Каждый шнекоротор обрабатывается в своем независимом блоке,
// чтобы избежать синтаксических ошибок и сложной логики.

// --- ОБРАБОТКА ЗАДАЧ ШНЕКОРОТОРА А ---
{ shnekorotor_A_task == "expand_7_to_4":
    ~ zone_4_accessible = true
    ~ shnekorotor_A_status = "discharged"
}
{ shnekorotor_A_task == "expand_7_to_8":
    ~ zone_8_accessible = true
    ~ shnekorotor_A_status = "discharged"
}
{ shnekorotor_A_task == "expand_4_to_1":
    ~ zone_1_accessible = true
    ~ shnekorotor_A_status = "discharged"
}
{ shnekorotor_A_task == "expand_4_to_5":
    ~ zone_5_accessible = true
    ~ shnekorotor_A_status = "discharged"
}


// --- ОБРАБОТКА ЗАДАЧ ШНЕКОРОТОРА B ---
{ shnekorotor_B_task == "expand_2_to_1":
    ~ zone_1_accessible = true
    ~ shnekorotor_B_status = "discharged"
}
{ shnekorotor_B_task == "expand_2_to_3":
    ~ zone_3_accessible = true
    ~ shnekorotor_B_status = "discharged"
}
{ shnekorotor_B_task == "expand_2_to_5":
    ~ zone_5_accessible = true
    ~ shnekorotor_B_status = "discharged"
}


// --- ОБРАБОТКА ЗАДАЧ ШНЕКОРОТОРА C ---
{ shnekorotor_C_task == "expand_9_to_6":
    ~ zone_6_accessible = true
    ~ shnekorotor_C_status = "discharged"
}
{ shnekorotor_C_task == "expand_9_to_8":
    ~ zone_8_accessible = true
    ~ shnekorotor_C_status = "discharged"
}
{ shnekorotor_C_task == "expand_6_to_3":
    ~ zone_3_accessible = true
    ~ shnekorotor_C_status = "discharged"
}
{ shnekorotor_C_task == "expand_6_to_5":
    ~ zone_5_accessible = true
    ~ shnekorotor_C_status = "discharged"
}

// ОТЛАДКА: Проверяем, изменилась ли зона
DEBUG_ZONE_1_STATUS: {zone_1_accessible}

    // --- ВОЗВРАЩЕНИЕ ДОМОЙ В КОНЦЕ ХОДА ---
    ~ nadya_location = 7
    ~ artem_location = 2
    ~ ignat_location = 9
    ~ masha_location = 9

    -> resolution_phase.final_checks

// === game_over_knot ===
// Этот узел срабатывает, когда игра закончена.
=== game_over_knot ===
# clear
Игра окончена.

// В будущем мы расширим этот узел, чтобы он показывал разные сообщения
// в зависимости от значения переменной game_result.
{game_result == "поражение_холод"}:
    В поселке стало слишком холодно. Родителей пришлось разбудить.

{game_result == "поражение_травма"}:
    Травмы малышей стали слишком серьезными. Родителей пришлось разбудить.

{game_result == "1_звезда"}:
    Вы продержались до прибытия помощи! Это была тяжелая вахта, но вы справились.

-> END

// =======================================================
// СЕКЦИЯ 4: ДИАЛОГИ, СОБЫТИЯ И КОНЦОВКИ
// Здесь лежат все "самостоятельные" сцены.
// Игра попадает сюда по команде -> из других узлов
// и так же по команде -> возвращается обратно.
// =======================================================

=== intro_1 ===
# clear
# image: "images/berloga_high_tech_snow.jpg"

(Панорама футуристического, но уютного поселка. В архитектуре угадываются мотивы берлог, но сквозь метель видны огоньки автоматических дронов-помощников и контуры обтекаемых аэромобилей, припаркованных у домов.)

2125 год. Планета Берлога. Здесь, в гармонии высоких технологий и суровой северной природы, процветает цивилизация разумных медведей.

Но даже в мире летающих дирижаблей и энергомеда древние инстинкты берут свое. Каждую зиму, когда холода становятся слишком сильными, все взрослые медведи погружаются в Великую Зимнюю Спячку, доверяя поддержание жизни в поселке своим детям-подросткам.

+ [Далее...]
    -> intro_2a

=== intro_2a ===
# clear
# image: "images/family_sledopytov.jpg"

В центре нашего поселка - три семьи, следующие разным Традициям.

СЛЕДОПЫТОВЫ, из Традиции Первопроходцев. Их девиз - "Всегда вперед!". Подросток Надя - их достойная дочь: спортивная, ответственная и готовая к любым вызовам. А вот малыш Андрейка (названный в честь дяди Бруса!) понимает девиз по-своему, "прокладывая путь" к внутренностям любой техники со словами "оно само сломалось!".

+ [Далее...]
    // Переходим к следующей семье
    -> intro_2b

=== intro_2b ===
# clear
# image: "images/family_voskoboinikov.jpg"

 ВОСКОБОЙНИКОВЫ, из Традидии Конструкторов. Но их сын Артем - "белая ворона" в семье. Его сердце принадлежит не механизмам, а биологии и его экспериментальным персикам в теплице. А его сестрички-близняшки Соня и Тоня - главный источник работы для медпункта, ведь они умудряются найти приключения на ровном месте.

+ [Далее...]
    // Переходим к последней семье
    -> intro_2c

=== intro_2c ===
# clear
# image: "images/family_gladkov.jpg"

ГЛАДКОВЫ, из Тради-ции Биоинженеров-медиков. Их родители - адепты ЗОЖа, но подростки Игнат и Маша предпочитают лыжам и пробежкам код и паяльник. Игнат - блестящий программист, а Маша - гениальный инженер. Этот дуэт может починить все. За ними приглядывает тихий малыш Кирилка, который больше всего на свете любит агрономию и свои "апельсинчики" в теплице.

+ [Далее...]
    // После рассказа о всех семьях переходим к следующей части вступления
    -> intro_3

=== intro_3 ===
# clear
# image: "images/nadya_room_calm.jpg"

(Комната Нади. На столе рядом с терминалом лежит значок Первопроходца.)

Пока взрослые спят, подростки несут "Снежную вахту" - поочередно дежурят в поселковом кризис-центре, следя за системами.

Сегодня очередь **Нади**. Для нее это не просто дежурство. Это шанс доказать, что она достойна своей Традиции. Шанс показать, что на нее можно положиться в самой сложной ситуации.

+ [Далее...]
    -> intro_4

=== intro_4 ===
# clear
# image: "images/nadya_room_alarm.jpg"

(Та же комната, но за окном бушует метель, а на голографическом проекторе мигает красная иконка "СБОЙ СИСТЕМЫ".)

Этой ночью буран оказался сильнее, чем предсказывали все симуляторы. Надя проснулась от воя сирены. Тревожный сигнал с Теплостанции. Отказ генератора. Обрыв связи с Медпунком.

Спасательная служба уже в пути, но их дирижабль сможет пробиться сквозь бурю не раньше, чем через 12 часов.

Испытание, о котором она думала, оказалось куда серьезнее, чем она могла себе представить.

+ [Собрать всех на экстренную видеосвязь]
    // Теперь мы переходим к старому диалогу-конференции,
    // который теперь будет звучать гораздо осмысленнее.
    -> initial_briefing

=== initial_briefing ===
// Мы используем теги (#), чтобы обозначить, кто говорит.
// В будущем, при подключении к движку Unity/Godot, вы сможете
// использовать эти теги, чтобы показывать портреты персонажей.

# speaker: Надя
(Сигнал видеосвязи устанавливается. На экране появляются окошки с сонными, но решительными мордами подростков.)
Надя: "Так, все на связи? Отлично. Сводка, как вы знаете, неутешительная. Буран отрезал нас от внешнего мира, все взрослые в Спячке. Спасатели будут через 12 часов."

# speaker: Артем
Артем: "12 часов... Надя, Теплостанция не работает. Мы долго не протянем. А еще... я только что осматривал Соню и Тоню. Они в порядке, но если с ними что-то случится, наш Медпункт тоже обесточен."

# speaker: Игнат
Игнат: (Ворчит, ковыряясь в какой-то железке за кадром) "Обесточен - это мягко сказано. Генератор в хлам. Мы с Машей можем его починить, но нам нужны запчасти со Склада. Руками мы их не дотащим."

# speaker: Маша
Маша: "Не ворчи, Игнат. Мы справимся! Надя, Артем, вы же у нас логисты. Если вы сможете организовать доставку деталей со Склада, мы с братом починим все, что угодно!"

# speaker: Надя
Надя: "Вот это и есть наш план. Слушайте все. Распределяем роли:"
Надя: "Игнат, Маша - вы наши инженеры. Ваша задача - чинить. Сидите наготове и сообщайте, что вам нужно. Без вас мы просто замерзнем."
Надя: "Артем - ты наш медик. Главная задача - следить за двойняшками. Если они получат травму, только ты сможешь им помочь в работающем Медпункте. Ну и... можешь помогать с доставкой, если будет свободная минутка."
Надя: "Я беру на себя общую координацию и основную логистику. Я буду доставлять запчасти инженерам, чтобы они не тратили время."
# speaker: Надя
Надя: "Помните, мы команда. Каждое наше действие на счету. Вопросы есть?"

// Здесь начинаются выборы
+ [Нет, всё предельно ясно. Пора за работу!]
    -> all_clear
+ [У меня вопрос про малышей. Что с ними делать?]
    -> about_kids

= all_clear
    # speaker: Игнат
    Игнат: "Вот и отлично. Давайте уже начинать, пока у меня тут все окончательно не заиндевело."
    -> end_of_briefing// Переходим к общему концу диалога

= about_kids
    # speaker: Надя
    Надя: "Хороший вопрос. За ними нужно постоянно присматривать. Игнат, Маша, Кирилка на вас. Артем, двойняшки на тебе. Я присмотрю за Андрейкой. Но это отнимает время... возможно, позже мы придумаем что-то получше."
    -> end_of_briefing // Тоже переходим к общему концу

= end_of_briefing
// Общая концовка сцены
+ [Начнем]
    -> main_game_loop

=== kirillka_hijack_dialogue ===
# clear
В начале часа Надя замечает странные следы на снегу.
"Похоже, кто-то брал технику..." - говорит она по рации.
Внезапно в эфире раздается голос Игната: "Это Кирилка! Я почти уверен, он опять пытается добраться до своей теплицы. Говорит, что его экспериментальные морозоустойчивые апельсины без него погибнут!"

+ [Сказать ему, что это слишком опасно]
    "Игнат, передай ему, что это очень опасно! Мы не можем рисковать техникой."
    -> continue_game
    
+ [Спросить, можем ли мы ему помочь]
    "Игнат, а что если мы поможем ему? Если мы расчистим путь к теплице и отправим его туда, может, он перестанет шалить и займется своими апельсинами?"
    -> continue_game

= continue_game
~ kirillka_hijack_dialogue_seen = true // СТАВИМ ВТОРОЙ ФЛАГ: "ДИАЛОГ ПРОСМОТРЕН"
// Этот флаг нужен, чтобы диалог не повторялся каждый ход.
Хорошо, нужно принять это к сведению.
+ [Продолжить]
    -> main_game_loop // ВОЗВРАЩАЕМСЯ В ОСНОВНОЙ ЦИКЛ ИГРЫ
    
=== club_unlock_dialogue ===
# clear
"Отлично!" - раздается в рации голос Нади. - "Шнекоротор пробился к Клубу! Теперь у нас есть безопасное место, куда можно отвести малышей, чтобы они не путались под лапами".
"Наконец-то," - ворчит Игнат. - "Только не забудьте, что их туда еще довести надо. Это займет время".
+ [Принять к сведению]
    ~ club_unlocked_dialogue_seen = true
    -> main_game_loop // Возвращаемся в основной цикл

=== kirillka_bored_dialogue ===
# clear
По рации доносится голос Маши: "Надя, у нас тут... дипломатический кризис. Кирилка в Клубе сидеть отказывается. Говорит, скучно ему."
Игнат на фоне: "Пусть не выдумывает! Делом бы лучше занялся!"
Кирилка, перекрикивая: "Я и хочу делом! Только интересным! Мои апельсины в Теплице без меня не выживут!"
+ [Сказать, чтобы не выдумывал и сидел смирно]
    "Маша, скажите ему, чтобы сидел тихо. Сейчас не до капризов."
    ~ kirillka_bored_dialogue_seen = true // Диалог видели, но опцию не открыли
    -> main_game_loop
+ [Спросить, чем можно помочь]
    "Погоди, Игнат. А что если он прав? Может, в Теплице он и правда будет полезнее? Артем, ты у нас в апельсинах разбираешься. Не напортачит он там?"
    ~ kirillka_bored_dialogue_seen = true
    ~ kirillka_greenhouse_option_unlocked = true // РАЗБЛОКИРОВКА!
    -> main_game_loop
    