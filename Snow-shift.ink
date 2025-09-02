// =================================================================
// СНЕЖНАЯ ВАХТА: БАЗА ДАННЫХ ИГРЫ (ПЕРЕМЕННЫЕ)
// Шаг 1: Определение всех состояний и счетчиков
// =================================================================

// -----------------------------------------------------------------
// 1. ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ИГРЫ
// -----------------------------------------------------------------
VAR turns_until_rescue = 8   // Сколько всего ходов нужно продержаться
VAR current_turn = 1          // Текущий ход
VAR game_over = false         // Флаг для завершения игрового цикла (true = игра окончена)
VAR game_result = ""          // Сюда запишем результат: "поражение", "1_звезда", "2_звезды", "3_звезды"
VAR heat_station_just_fixed = false
VAR med_point_just_fixed = false
VAR greenhouse_just_fixed = false
VAR andreyka_last_sabotage = "none" // Что Андрейка сломал на прошлом ходу
VAR expansion_event_happened = false // Произошла ли расчистка завала на прошлом ходу
VAR club_drone_repair_authorized = false
VAR greenhouse_drone_repair_authorized = false
VAR club_repair_dialogue_seen = false
VAR greenhouse_repair_dialogue_seen = false

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
VAR first_mischief_dialogue_seen = false // Случилась ли уже первая шалость?

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
VAR parts_at_warehouse = 7  // Сколько всего запчастей на складе (6)
// Запчасти, доставленные на место для ремонта
VAR parts_at_club = 0 // Локация 3
VAR parts_at_greenhouse = 0 // Локация 4
VAR parts_at_heat_station = 0 // Локация 8
VAR parts_at_med_point = 0    // Локация 5
VAR parts_at_shnek_A_base = 0 // Запчасти на базе Шнекоротора А (зона 7)
VAR parts_at_shnek_B_base = 0 // Запчасти на базе Шнекоротора B (зона 2)
VAR parts_at_shnek_C_base = 0 // Запчасти на базе Шнекоротора C (зона 9)

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
// Проверка диалога об открытии Клуба
{ zone_3_accessible and not club_unlocked_dialogue_seen:
    -> club_unlock_dialogue
}
// Проверка диалога о скучающем Кирилке
// Условие: Кирилка в клубе, путь до Теплицы (4) от его дома (9) открыт, и диалог не видели
{ kirillka_location == "club" and zone_8_accessible and zone_5_accessible and zone_4_accessible and not kirillka_bored_dialogue_seen:
    -> kirillka_bored_dialogue
}

// Проверка диалога о Кирилке, угнавшем шнекоротор
{ kirillka_hijack_event_triggered and not kirillka_hijack_dialogue_seen:
    -> kirillka_hijack_dialogue
}

// Первым делом мы проверяем, не закончилась ли игра.
// 1. Счетчик ходов исчерпан (победа).
{ turns_until_rescue < current_turn:
    ~ game_over = true
    // Теперь проверяем дронов, чтобы определить результат
    {club_drone_status == "ok" and greenhouse_drone_status == "ok":
        // Оба дрона починены
        ~ game_result = "3_звезды"
    - else:
        {club_drone_status == "ok" or greenhouse_drone_status == "ok":
            // Только один дрон починен
            ~ game_result = "2_звезды"
        - else:
            // Ни один дрон не починен
            ~ game_result = "1_звезда"
        }
    }
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
// --- ЭТАП 1.1: ПРОВЕРКА ПЕРВОЙ ШАЛОСТИ ---
{ (andreyka_activity == "naughty" or sonya_tonya_activity == "naughty" or kirillka_activity == "naughty") and not first_mischief_dialogue_seen:
    ~ first_mischief_dialogue_seen = true
    -> first_mischief_dialogue
- else:
    -> check_expansion_event // Переходим к следующему шагу отчета
}
= check_expansion_event
// --- ЭТАП 1.2: ПРОВЕРКА СЦЕНЫ РАСЧИСТКИ ЗАВАЛА ---
{ expansion_event_happened:
    ~ expansion_event_happened = false
    
    #Location: Расчистка завала
    # clear
    С ревом и скрежетом металла шнекоротор вгрызается в плотный снег. Огромные фрезы перемалывают лед и отбрасывают снежную крошку на десятки метров. Еще мгновение — и стена снега, отрезавшая вас от другой части поселка, рушится. Путь расчищен. Доступна новая зона!
    + [Продолжить]
        -> check_greenhouse_event // Переходим к следующей проверке
- else:
    -> check_greenhouse_event // Если события не было, все равно переходим к следующей проверке
}

// --- ЭТАП 2: ПРОВЕРКА СЦЕНЫ ПОЧИНКИ ТЕПЛИЦЫ ---
= check_greenhouse_event
{ greenhouse_just_fixed:
    ~ greenhouse_just_fixed = false
    
    #Location: Теплица
    # clear
    Маша: Есть! Системы Теплицы перезапущены! Артем, может, персики теперь смогут выжить! #Р
    + [Отлично!]
        -> show_main_report // Переходим к основному отчету
- else:
    -> show_main_report // Если события не было, все равно переходим к основному отчету
}

// --- ЭТАП 3: ПОКАЗ ОСНОВНОГО ОТЧЕТА ---
= show_main_report
#Location: Карта
# clear

+ [Наступил {current_turn}-й час вахты. Получить сводку.]

    // --- БЛОК СРОЧНЫХ ОПОВЕЩЕНИЙ ---
    { andreyka_last_sabotage != "none":
        # alert: ТРЕВОГА!
        В предыдущий час Андрейка-таки добрался до оборудования!.. <>
        {
            - andreyka_last_sabotage == "heat_station":
                Он снова сломал Теплостанцию!
            - andreyka_last_sabotage == "med_point":
                Он вывел из строя Медпункт!
            - andreyka_last_sabotage == "greenhouse":
                Он повредил системы Теплицы!
            - andreyka_last_sabotage == "shnek_A":
                Он сломал Шнекоротор А!
            - andreyka_last_sabotage == "shnek_B":
                Он сломал Шнекоротор B!
            - andreyka_last_sabotage == "shnek_C":
                Он сломал Шнекоротор C!
        }
    }

    // --- БЛОК РЕАКЦИЙ НА РЕМОНТ ---
    { heat_station_just_fixed:
        ~ heat_station_just_fixed = false
        Игнат: Теплостанция снова в строю. На какое-то время можно выдохнуть. #Р
    }
    { med_point_just_fixed:
        ~ med_point_just_fixed = false
        Артем: Слава предкам, Медпункт работает! Теперь я смогу помочь, если что-то случится. #Р
    }
    
    // --- ОСНОВНАЯ СВОДКА ---
    -- Состояние систем: <>
    --- Теплостанция: {heat_station_status == "ok": в порядке| сломана}. {heat_station_broken_turns > 0: ВНИМАНИЕ! Не работает уже {heat_station_broken_turns} час(а)!|} <>
    --- Медпункт: {med_point_status == "ok": в порядке| сломан}. <>
    --- Теплица: {greenhouse_status == "ok": в порядке| сломана}. <>
    -- Здоровье малышей: <>
    --- Соня и Тоня {sonya_tonya_health_status == "healthy": здоровы| ранены}. {sonya_tonya_injured_turns > 0: ВНИМАНИЕ! Они ранены уже {sonya_tonya_injured_turns} час(а)!|} <>
    -- Ресурсы: <>
    --- Запчастей на складе: {parts_at_warehouse}.

    -> reset_phase


=== reset_phase ===
    ~ nadya_task = "none"
    ~ artem_task = "none"
    ~ ignat_task = "none"
    ~ masha_task = "none"
    ~ shnekorotor_A_task = "none"
    ~ shnekorotor_B_task = "none"
    ~ shnekorotor_C_task = "none"
    ~ andreyka_last_sabotage = "none"
-> assignment_phase
    
// === assignment_phase ===
// Этот узел теперь - просто контейнер для цикла назначения.
=== assignment_phase ===

// Это "якорь" (stitch), к которому мы будем возвращаться.
= assignment_loop
    #Location: Карта
    # clear
    Задачи на этот час: <>
    - Надя Следопытова: {task_to_russian(nadya_task)} <>
    - Артем Воскобойников: {task_to_russian(artem_task)} <>
    - Игнат Гладков: {task_to_russian(ignat_task)} <>
    - Маша Гладкова: {task_to_russian(masha_task)} <>
    - Шнекоротор А (База 7): {shnekorotor_A_status == "charged": {task_to_russian(shnekorotor_A_task)} | {shnekorotor_A_status == "discharged": разряжен | сломан}} <>
    - Шнекоротор B (База 2): {shnekorotor_B_status == "charged": {task_to_russian(shnekorotor_B_task)} | {shnekorotor_B_status == "discharged": разряжен | сломан}} <>
    - Шнекоротор C (База 9): {shnekorotor_C_status == "charged": {task_to_russian(shnekorotor_C_task)} | {shnekorotor_C_status == "discharged": разряжен | сломан}}
    
    // Этот gather (дефис) "перезагружает" список выборов при каждом заходе
    -
    + {nadya_task == "none"} [Назначить задачу Надежде] -> assign_nadya
    + {artem_task == "none"} [Назначить задачу Артему] -> assign_artem
    + {ignat_task == "none"} [Назначить задачу Игнату] -> assign_ignat
    + {masha_task == "none"} [Назначить задачу Маше] -> assign_masha
    
    + {shnekorotor_A_status == "charged" and shnekorotor_A_task == "none"} [Назначить задачу Шнекоротору А] -> assign_shnek_A
    + {shnekorotor_B_status == "charged" and shnekorotor_B_task == "none"} [Назначить задачу Шнекоротору B] -> assign_shnek_B
    + {shnekorotor_C_status == "charged" and shnekorotor_C_task == "none"} [Назначить задачу Шнекоротору C] -> assign_shnek_C
    
    + [Все задачи распределены, начать выполнение] -> malyshi_ai_phase

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
    + {zone_6_accessible and zone_7_accessible} [Доставить запчасть для Шнекоротора А (на базу 7)]
        ~ nadya_task = "deliver_part_to_shnek_A"
        -> assignment_loop
    + {zone_6_accessible and zone_2_accessible} [Доставить запчасть для Шнекоротора B (на базу 2)]
        ~ nadya_task = "deliver_part_to_shnek_B"
        -> assignment_loop
    + {zone_6_accessible and zone_9_accessible} [Доставить запчасть для Шнекоротора C (на базу 9)]
        ~ nadya_task = "deliver_part_to_shnek_C"
        -> assignment_loop
    + { andreyka_location == "home" } [Присмотреть за Андрейкой (в доме 7)]
        ~ nadya_task = "babysit_andreyka"
        -> assignment_loop
  // НОВАЯ ЗАДАЧА: Отвести "своего" малыша в Клуб
    + { andreyka_location == "home" and zone_8_accessible and zone_6_accessible and zone_3_accessible } [Отвести Андрейку в Клуб (3)]
        ~ nadya_task = "escort_andreyka_to_club"
        -> assignment_loop
    + [Отмена] -> assignment_loop

= assign_artem
    + {zone_5_accessible and med_point_status == "ok" and sonya_tonya_health_status == "injured"} [Лечить в Медпункте (5)]
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
    + {zone_6_accessible and zone_7_accessible} [Доставить запчасть для Шнекоротора А (на базу 7)]
        ~ artem_task = "deliver_part_to_shnek_A"
        -> assignment_loop
    + {zone_6_accessible and zone_2_accessible} [Доставить запчасть для Шнекоротора B (на базу 2)]
        ~ artem_task = "deliver_part_to_shnek_B"
        -> assignment_loop
    + {zone_6_accessible and zone_9_accessible} [Доставить запчасть для Шнекоротора C (на базу 9)]
        ~ artem_task = "deliver_part_to_shnek_C"
        -> assignment_loop
    + {sonya_tonya_location == "home"} [Присмотреть за Соней и Тоней (в доме 2)]
        ~ artem_task = "babysit_sonya_tonya"
        -> assignment_loop
    + { sonya_tonya_location == "home" and zone_3_accessible } [Отвести Соню и Тоню в Клуб (3)]
        ~ artem_task = "escort_sonya_tonya_to_club"
        -> assignment_loop
    + {greenhouse_status == "ok" and kirillka_greenhouse_option_unlocked and kirillka_location != "greenhouse" and ( (zone_4_accessible and zone_5_accessible and zone_6_accessible) or (zone_4_accessible and zone_8_accessible) or (zone_1_accessible and zone_6_accessible) )} [Отправить Кирилку в Теплицу (4)]
        ~ artem_task = "escort_kirillka_to_greenhouse"
        -> assignment_loop

    + [Отмена] -> assignment_loop
    
= assign_ignat
    // Починка основных объектов требует доступа к их зонам
    + {zone_8_accessible and heat_station_status == "broken"} [Чинить Теплостанцию (8) Требуется запчасть!]
        ~ ignat_task = "fix_heat_station"
        -> assignment_loop
    + {zone_5_accessible and med_point_status == "broken"} [Чинить Медпункт (5) Требуется запчасть!]
        ~ ignat_task = "fix_med_point"
        -> assignment_loop
    + {zone_4_accessible and greenhouse_status == "broken"} [Чинить Теплицу (4) Требуется запчасть!]
        ~ ignat_task = "fix_greenhouse"
        -> assignment_loop

    // Починка шнекороторов не требует доступа к базам, потому что они по умолчанию доступны.
    + {shnekorotor_A_status == "broken" and zone_7_accessible} [Починить Шнекоротор А (на базе 7) Требуется запчасть!]
        ~ ignat_task = "fix_shnek_A"
        -> assignment_loop
    + {shnekorotor_B_status == "broken" and zone_2_accessible} [Починить Шнекоротор B (на базе 2) Требуется запчасть!]
        ~ ignat_task = "fix_shnek_B"
        -> assignment_loop
    + {shnekorotor_C_status == "broken" and zone_9_accessible} [Починить Шнекоротор C (на базе 9) Требуется запчасть!]
        ~ ignat_task = "fix_shnek_C"
        -> assignment_loop
    + {kirillka_location == "home"} [Присмотреть за Кирилкой (в доме 9)]
        ~ ignat_task = "babysit_kirillka"
        -> assignment_loop
        // НОВАЯ ЗАДАЧА: Отвести "своего" малыша в Клуб
    + {kirillka_location == "home" and zone_3_accessible and zone_6_accessible} [Отвести Кирилку в Клуб (3)]
        ~ ignat_task = "escort_kirillka_to_club"
        -> assignment_loop
    + [Отмена] -> assignment_loop

// Узел для Маши будет ИДЕНТИЧНЫМ, просто замените "ignat" на "masha"
= assign_masha
    // Починка основных объектов требует доступа к их зонам
    + {zone_8_accessible and heat_station_status == "broken"} [Чинить Теплостанцию (8) Требуется запчасть!]
        ~ masha_task = "fix_heat_station"
        -> assignment_loop
    + {zone_5_accessible and med_point_status == "broken"} [Чинить Медпункт (5) Требуется запчасть!]
        ~ masha_task = "fix_med_point"
        -> assignment_loop
    + {zone_4_accessible and greenhouse_status == "broken"} [Чинить Теплицу (4) Требуется запчасть!]
        ~ masha_task = "fix_greenhouse"
        -> assignment_loop

    // Починка шнекороторов, ровно как у Игната
    + {shnekorotor_A_status == "broken"} [Починить Шнекоротор А (на базе 7) Требуется запчасть!]
        ~ masha_task = "fix_shnek_A"
        -> assignment_loop
    + {shnekorotor_B_status == "broken"} [Починить Шнекоротор B (на базе 2) Требуется запчасть!]
        ~ masha_task = "fix_shnek_B"
        -> assignment_loop
    + {shnekorotor_C_status == "broken"} [Починить Шнекоротор C (на базе 9) Требуется запчасть!]
        ~ masha_task = "fix_shnek_C"
        -> assignment_loop
    + {kirillka_location == "home"} [Присмотреть за Кирилкой (в доме 9)]
        ~ masha_task = "babysit_kirillka"
        -> assignment_loop
    + {kirillka_location == "home" and zone_3_accessible and zone_6_accessible} [Отвести Кирилку в Клуб (3)]
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

// === malyshi_ai_phase ===
// Это ОТДЕЛЬНАЯ, скрытая комната для логики малышей.
=== malyshi_ai_phase ===
Надя кидает взгляд на мониторы, напоминая себе: нельзя забывать о малышах, ведь это главная ответственность всех подростков!
+ [Продолжить]
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
    { nadya_task == "babysit_andreyka" or nadya_task == "escort_andreyka_to_club":
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
    { artem_task == "babysit_sonya_tonya" or artem_task == "escort_sonya_tonya_to_club":
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
    { ignat_task == "babysit_kirillka" or masha_task == "babysit_kirillka" or ignat_task == "escort_kirillka_to_club" or masha_task == "escort_kirillka_to_club" or artem_task == "escort_kirillka_to_greenhouse":
        ~ kirillka_activity = "busy"
    - else:
        ~ kirillka_activity = "naughty"
    }
}

// =================================================================
// СЕКЦИЯ 2: ВЫПОЛНЕНИЕ ДЕЙСТВИЙ ПО РЕЗУЛЬТАТАМ
// =================================================================

// --- "Полезные" действия ---
{ (andreyka_activity == "useful" or sonya_tonya_activity == "useful") and club_drone_status == "broken" and club_drone_repair_authorized:
    ~ club_drone_status = "ok"
    ~ parts_at_club = parts_at_club - 1
}

{ kirillka_activity == "useful" and kirillka_location == "greenhouse" and greenhouse_drone_status == "broken" and greenhouse_drone_repair_authorized:
    ~ greenhouse_drone_status = "ok"
    ~ parts_at_greenhouse = parts_at_greenhouse - 1
}

// --- "Шаловливые" действия ---

// УСИЛЕННАЯ Логика Андрейки (ломает ОДНУ вещь за ход, но с приоритетом)
{ andreyka_activity == "naughty":
    // --- ПРИОРИТЕТ 1: Сломать уже починенную Теплостанцию ---
    { heat_station_status == "ok":
        ~ heat_station_status = "broken"
        ~ andreyka_last_sabotage = "heat_station"
    
    // --- ПРИОРИТЕТ 2: Сломать уже починенный Медпункт ---
    - else:
        { med_point_status == "ok":
            ~ med_point_status = "broken"
            ~ andreyka_last_sabotage = "med_point"
        
        // --- ПРИОРИТЕТ 3: Сломать уже починенную Теплицу ---
        - else:
            { greenhouse_status == "ok":
                ~ greenhouse_status = "broken"
                ~ andreyka_last_sabotage = "greenhouse"
            
            // --- ПРИОРИТЕТ 4: Если ничего важного не починено, ломает шнекороторы ---
            - else:
                { shnekorotor_A_status == "charged":
                    ~ shnekorotor_A_status = "broken"
                    ~ andreyka_last_sabotage = "shnek_A"
                - else:
                    { shnekorotor_B_status == "charged":
                        ~ shnekorotor_B_status = "broken"
                        ~ andreyka_last_sabotage = "shnek_B"
                    - else:
                        { shnekorotor_C_status == "charged":
                            ~ shnekorotor_C_status = "broken"
                            ~ andreyka_last_sabotage = "shnek_C"
                        }
                    }
                }
            }
        }
    }
}

// Логика Сони и Тони
{ sonya_tonya_activity == "naughty" and sonya_tonya_health_status == "healthy":
    ~ sonya_tonya_health_status = "injured"
}

// --- НОВЫЙ БЛОК: УВЕЛИЧЕНИЕ СЧЕТЧИКОВ СРАЗУ ПОСЛЕ СОБЫТИЙ ---
{ heat_station_status == "broken":
    ~ heat_station_broken_turns = heat_station_broken_turns + 1
}
{ sonya_tonya_health_status == "injured":
    ~ sonya_tonya_injured_turns = sonya_tonya_injured_turns + 1
}
// --- КОНЕЦ НОВОГО БЛОКА ---


// Логика Кирилки (УГОН ТЕПЕРЬ ЛОМАЕТ ТЕХНИКУ)
{ kirillka_activity == "naughty":
    // --- ПРИОРИТЕТ 1: Открыть путь 9 -> 8 ---
    { not zone_8_accessible:
        { shnekorotor_C_status == "charged":
            ~ zone_8_accessible = true
            ~ shnekorotor_C_status = "broken"
            ~ kirillka_hijack_event_triggered = true
        - else:
            { shnekorotor_B_status == "charged":
                ~ zone_8_accessible = true
                ~ shnekorotor_B_status = "broken"
                ~ kirillka_hijack_event_triggered = true
            - else:
                { shnekorotor_A_status == "charged":
                    ~ zone_8_accessible = true
                    ~ shnekorotor_A_status = "broken"
                    ~ kirillka_hijack_event_triggered = true
                }
            }
        }
    - else:
        // --- ПРИОРИТЕТ 2: Если 9->8 открыт, открываем 9 -> 6 ---
        { not zone_6_accessible:
            { shnekorotor_C_status == "charged":
                ~ zone_6_accessible = true
                ~ shnekorotor_C_status = "broken"
                ~ kirillka_hijack_event_triggered = true
            - else:
                { shnekorotor_B_status == "charged":
                    ~ zone_6_accessible = true
                    ~ shnekorotor_B_status = "broken"
                    ~ kirillka_hijack_event_triggered = true
                - else:
                    { shnekorotor_A_status == "charged":
                        ~ zone_6_accessible = true
                        ~ shnekorotor_A_status = "broken"
                        ~ kirillka_hijack_event_triggered = true
                    }
                }
            }
        - else:
            // --- ПРИОРИТЕТ 3: Если и те открыты, открываем 6 -> 5 ---
            { not zone_5_accessible:
                 { shnekorotor_C_status == "charged":
                    ~ zone_5_accessible = true
                    ~ shnekorotor_C_status = "broken"
                    ~ kirillka_hijack_event_triggered = true
                - else:
                    { shnekorotor_B_status == "charged":
                        ~ zone_5_accessible = true
                        ~ shnekorotor_B_status = "broken"
                        ~ kirillka_hijack_event_triggered = true
                    - else:
                        { shnekorotor_A_status == "charged":
                            ~ zone_5_accessible = true
                            ~ shnekorotor_A_status = "broken"
                            ~ kirillka_hijack_event_triggered = true
                        }
                    }
                }
            }
        }
    }
}

// =================================================================
// БЛОК ПЕРЕХОДА В КОНЦЕ ФАЗЫ
// =================================================================
// После определения действий малышей, всегда переходим к фазе действий игрока.
-> player_actions_phase

// =================================================================
// НОВАЯ, РАЗДЕЛЕННАЯ ФАЗА ДЕЙСТВИЙ ИГРОКА (СИНТАКСИС INK)
// =================================================================

// ШАГ 1: УЗЕЛ-ДИСПЕТЧЕР
=== player_actions_phase ===
Теперь все в поселке заняты, можно, наконец, заварить чай.
    -> process_special_triggers

// ШАГ 2.1: ПРОВЕРКА ПЕРВОГО ДИАЛОГА (КЛУБ)
= process_special_triggers
    { (nadya_task == "deliver_part_to_3" or artem_task == "deliver_part_to_3") and (andreyka_location == "club" or sonya_tonya_location == "club" or kirillka_location == "club") and club_drone_status == "broken" and not club_drone_repair_authorized and not club_repair_dialogue_seen:
        -> scene_initiate_club_repair
    - else:
        -> check_greenhouse_trigger // Если диалога про Клуб не было, сразу проверяем Теплицу
    }

// ШАГ 2.2: ПРОВЕРКА ВТОРОГО ДИАЛОГА (ТЕПЛИЦА)
= check_greenhouse_trigger
    { (nadya_task == "deliver_part_to_4" or artem_task == "deliver_part_to_4") and kirillka_location == "greenhouse" and greenhouse_drone_status == "broken" and not greenhouse_drone_repair_authorized and not greenhouse_repair_dialogue_seen:
        -> scene_initiate_greenhouse_repair
    - else:
        -> process_logistics_actions // Если и этого диалога не было, идем дальше по плану
    }

// ШАГ 3: СТЕЖОК ДЛЯ ЛОГИСТИКИ И СОПРОВОЖДЕНИЯ
= process_logistics_actions
    // --- ЗАДАЧИ НАДИ ---
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
    { nadya_task == "deliver_part_to_shnek_A" and parts_at_warehouse > 0:
        ~ parts_at_warehouse = parts_at_warehouse - 1
        ~ parts_at_shnek_A_base = parts_at_shnek_A_base + 1
        ~ nadya_location = 7
    }
    { nadya_task == "deliver_part_to_shnek_B" and parts_at_warehouse > 0:
        ~ parts_at_warehouse = parts_at_warehouse - 1
        ~ parts_at_shnek_B_base = parts_at_shnek_B_base + 1
        ~ nadya_location = 2
    }
    { nadya_task == "deliver_part_to_shnek_C" and parts_at_warehouse > 0:
        ~ parts_at_warehouse = parts_at_warehouse - 1
        ~ parts_at_shnek_C_base = parts_at_shnek_C_base + 1
        ~ nadya_location = 9
    }
    { nadya_task == "babysit_andreyka":
        ~ nadya_location = 7
    }
    { nadya_task == "escort_andreyka_to_club":
        ~ andreyka_location = "club"
        ~ nadya_location = 3
    }

    // --- ЛОГИСТИЧЕСКИЕ ЗАДАЧИ АРТЕМА ---
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
    { artem_task == "deliver_part_to_shnek_A" and parts_at_warehouse > 0:
        ~ parts_at_warehouse = parts_at_warehouse - 1
        ~ parts_at_shnek_A_base = parts_at_shnek_A_base + 1
        ~ artem_location = 7
    }
    { artem_task == "deliver_part_to_shnek_B" and parts_at_warehouse > 0:
        ~ parts_at_warehouse = parts_at_warehouse - 1
        ~ parts_at_shnek_B_base = parts_at_shnek_B_base + 1
        ~ artem_location = 2
    }
    { artem_task == "deliver_part_to_shnek_C" and parts_at_warehouse > 0:
        ~ parts_at_warehouse = parts_at_warehouse - 1
        ~ parts_at_shnek_C_base = parts_at_shnek_C_base + 1
        ~ artem_location = 9
    }
    { artem_task == "babysit_sonya_tonya":
        ~ artem_location = 2
    }
    { artem_task == "escort_sonya_tonya_to_club":
        ~ sonya_tonya_location = "club"
        ~ artem_location = 3
    }
    { artem_task == "escort_kirillka_to_greenhouse":
        ~ kirillka_location = "greenhouse"
        ~ artem_location = 4
    }
    
    -> process_medical_actions

// ШАГ 4: СТЕЖОК ДЛЯ МЕДИЦИНСКИХ ДЕЙСТВИЙ
= process_medical_actions
    { artem_task == "heal" and med_point_status == "ok" and sonya_tonya_health_status == "injured":
        ~ sonya_tonya_health_status = "healthy"
        ~ sonya_tonya_injured_turns = 0
        ~ artem_location = 5
    }
    -> process_engineering_actions

// ШАГ 5: СТЕЖОК ДЛЯ ИНЖЕНЕРНЫХ РАБОТ И ЗАБОТЫ О КИРИЛКЕ
= process_engineering_actions
    // --- Починка Теплостанции (8) ---
    { (ignat_task == "fix_heat_station" or masha_task == "fix_heat_station") and heat_station_status == "broken" and parts_at_heat_station > 0:
        ~ heat_station_status = "ok"
        ~ heat_station_just_fixed = true
        ~ heat_station_broken_turns = 0
        ~ parts_at_heat_station = parts_at_heat_station - 1
        
        { ignat_task == "fix_heat_station":
            ~ ignat_location = 8
        }
        { masha_task == "fix_heat_station":
            ~ masha_location = 8
        }
    }
    
    // --- Починка Медпункта (5) ---
    { (ignat_task == "fix_med_point" or masha_task == "fix_med_point") and med_point_status == "broken" and parts_at_med_point > 0:
        ~ med_point_status = "ok"
        ~ med_point_just_fixed = true
        ~ parts_at_med_point = parts_at_med_point - 1

        { ignat_task == "fix_med_point":
            ~ ignat_location = 5
        }
        { masha_task == "fix_med_point":
            ~ masha_location = 5
        }
    }

    // --- Починка Теплицы (4) ---
    { (ignat_task == "fix_greenhouse" or masha_task == "fix_greenhouse") and greenhouse_status == "broken" and parts_at_greenhouse > 0:
        ~ greenhouse_status = "ok"
        ~ greenhouse_just_fixed = true 
        ~ parts_at_greenhouse = parts_at_greenhouse - 1
        
        { ignat_task == "fix_greenhouse":
            ~ ignat_location = 4
        }
        { masha_task == "fix_greenhouse":
            ~ masha_location = 4
        }
    }

    // --- Починка Шнекоротора А (База 7) ---
    { (ignat_task == "fix_shnek_A" or masha_task == "fix_shnek_A") and shnekorotor_A_status == "broken" and parts_at_shnek_A_base > 0:
        ~ shnekorotor_A_status = "discharged"
        ~ parts_at_shnek_A_base = parts_at_shnek_A_base - 1
        { ignat_task == "fix_shnek_A":
            ~ ignat_location = 7
        }
        { masha_task == "fix_shnek_A":
            ~ masha_location = 7
        }
    }
    
    // --- Починка Шнекоротора B (База 2) ---
    { (ignat_task == "fix_shnek_B" or masha_task == "fix_shnek_B") and shnekorotor_B_status == "broken" and parts_at_shnek_B_base > 0:
        ~ shnekorotor_B_status = "discharged"
        ~ parts_at_shnek_B_base = parts_at_shnek_B_base - 1
        { ignat_task == "fix_shnek_B":
            ~ ignat_location = 2
        }
        { masha_task == "fix_shnek_B":
            ~ masha_location = 2
        }
    }

    // --- Починка Шнекоротора C (База 9) ---
    { (ignat_task == "fix_shnek_C" or masha_task == "fix_shnek_C") and shnekorotor_C_status == "broken" and parts_at_shnek_C_base > 0:
        ~ shnekorotor_C_status = "discharged"
        ~ parts_at_shnek_C_base = parts_at_shnek_C_base - 1
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
    -> process_shnekorotor_actions

// ШАГ 6: СТЕЖОК ДЛЯ ТЕХНИКИ
= process_shnekorotor_actions
    // --- ОБРАБОТКА ЗАДАЧ ШНЕКОРОТОРА А ---
    { shnekorotor_A_task == "expand_7_to_4":
        ~ zone_4_accessible = true
        ~ shnekorotor_A_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_A_task == "expand_7_to_8":
        ~ zone_8_accessible = true
        ~ shnekorotor_A_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_A_task == "expand_4_to_1":
        ~ zone_1_accessible = true
        ~ shnekorotor_A_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_A_task == "expand_4_to_5":
        ~ zone_5_accessible = true
        ~ shnekorotor_A_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_A_task == "expand_8_to_5":
        ~ zone_5_accessible = true
        ~ shnekorotor_A_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_A_task == "expand_8_to_9":
        ~ zone_9_accessible = true
        ~ shnekorotor_A_status = "discharged"
        ~ expansion_event_happened = true
    }
    
    // --- ОБРАБОТКА ЗАДАЧ ШНЕКОРОТОРА B ---
    { shnekorotor_B_task == "expand_2_to_1":
        ~ zone_1_accessible = true
        ~ shnekorotor_B_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_B_task == "expand_2_to_3":
        ~ zone_3_accessible = true
        ~ shnekorotor_B_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_B_task == "expand_2_to_5":
        ~ zone_5_accessible = true
        ~ shnekorotor_B_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_B_task == "expand_1_to_4":
        ~ zone_4_accessible = true
        ~ shnekorotor_B_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_B_task == "expand_5_to_4":
        ~ zone_4_accessible = true
        ~ shnekorotor_B_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_B_task == "expand_5_to_6":
        ~ zone_6_accessible = true
        ~ shnekorotor_B_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_B_task == "expand_5_to_8":
        ~ zone_8_accessible = true
        ~ shnekorotor_B_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_B_task == "expand_3_to_6":
        ~ zone_6_accessible = true
        ~ shnekorotor_B_status = "discharged"
        ~ expansion_event_happened = true
    }
    
    // --- ОБРАБОТКА ЗАДАЧ ШНЕКОРОТОРА C ---
    { shnekorotor_C_task == "expand_9_to_6":    
        ~ zone_6_accessible = true
        ~ shnekorotor_C_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_C_task == "expand_9_to_8":
        ~ zone_8_accessible = true
        ~ shnekorotor_C_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_C_task == "expand_6_to_3":
        ~ zone_3_accessible = true
        ~ shnekorotor_C_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_C_task == "expand_6_to_5":
        ~ zone_5_accessible = true
        ~ shnekorotor_C_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_C_task == "expand_8_to_5":
        ~ zone_5_accessible = true
        ~ shnekorotor_C_status = "discharged"
        ~ expansion_event_happened = true
    }
    { shnekorotor_C_task == "expand_8_to_7":
        ~ zone_7_accessible = true
        ~ shnekorotor_C_status = "discharged"
        ~ expansion_event_happened = true
    }

    -> end_of_turn_phase

// ШАГ 7: СТЕЖОК ЗАВЕРШЕНИЯ ХОДА
= end_of_turn_phase
Час подходит к концу. Пора подвести итог и спланировать следующие шаги!
+ [Надя снова склонилась над мониторами]
    ~ nadya_location = 7
    ~ artem_location = 2
    ~ ignat_location = 9
    ~ masha_location = 9

    { heat_station_broken_turns >= 3:
        ~ game_over = true
        ~ game_result = "поражение_холод"
    }
    { sonya_tonya_injured_turns >= 3:
        ~ game_over = true
        ~ game_result = "поражение_травма"
    }

    ~ current_turn = current_turn + 1
    -> main_game_loop

=== game_over_knot ===
# clear
{
    // -------------------------------------------------
    // СЦЕНАРИЙ ПОРАЖЕНИЯ: ХОЛОД (Взрослые проснулись)
    // -------------------------------------------------
    - game_result == "поражение_холод":
        #Location: Кризисный центр красный
        Надя: (смотрит на главный экран. Индикатор температуры мигает красным, а затем начинает выдавать тревожный сигнал. Температура слишком низкая) Я... я не справилась!.. #П
        С тяжелым сердцем Надя активирует протокол экстренного пробуждения. По всему поселку раздается оглушительный вой сирены, вырывающий взрослых из Великой Спячки. Вахта провалена.
        
        Отец Нади: (уже одетый в рабочий комбинезон, руководит ремонтом Теплостанции. Он подходит к дочери и протягивает ей кружку горячего какао) Ничего. Буран был сильнее прогнозов. Мы все починим. Это была лишь твоя первая вахта, будут и другие. И будут вызовы, где такой подстраховки уже не будет. Учись, Надя.
        Надя молча кивает, но чувствует невероятную горечь. Она провалила свою первую настоящую проверку.

    // -------------------------------------------------
    // СЦЕНАРИЙ ПОРАЖЕНИЯ: ТРАВМА (Взрослые проснулись)
    // -------------------------------------------------
    - game_result == "поражение_травма":
    #Location: Кризисный центр красный
        Артем: Надя, всё плохо! Очень плохо! Я не могу остановить кровь! Им нужна настоящая помощь, немедленно! #П
        Надя: Активирую экстренное пробуждение. Вахта провалена. #П
        
        (Воскобойниковы, родители Сони и Тони, разбуженные тревогой, выбегают из дома и бросаются к своим дочерям, которых уже осматривают Гладковы. Артем стоит в стороне, не в силах поднять взгляд. Его отец, известный Конструктор, подходит к нему.)
        Отец Артема: Ты сделал все, что мог в этих условиях, сын. Но ты должен понять: инструменты должны работать. Медпункт должен был быть в приоритете. (Артем лишь плотнее сжимает лапы. Урок был слишком жестоким)

    // -------------------------------------------------
    // СЦЕНАРИЙ ПОБЕДЫ: 1 ЗВЕЗДА (Часть 1)
    // -------------------------------------------------
    - game_result == "1_звезда":
        #Location: Кризисный центр желтый
        # clear
        Восемь часов. Восемь долгих, как вечность, часов. За окном вой вьюги внезапно прорезает низкий, уверенный гул.
        Надя: Слышите? Это они! Они здесь! #Р
        -> ending_1_star_part_2

    // -------------------------------------------------
    // СЦЕНАРИЙ ПОБЕДЫ: 2 ЗВЕЗДЫ (Часть 1)
    // -------------------------------------------------
    - game_result == "2_звезды":
        #Location: Кризисный центр зеленый
        # clear
        Гул спасательного дирижабля становится все громче. Надя с облегчением выдыхает. Они не просто продержались — они смогли навести порядок в поселке!
        -> ending_2_star_part_2

    // -------------------------------------------------
    // СЦЕНАРИЙ ПОБЕДЫ: 3 ЗВЕЗДЫ (Часть 1)
    // -------------------------------------------------
    - game_result == "3_звезды":
        #Location: Кризисный центр зеленый
        # clear
        Гул дирижабля — это уже не звук спасения. Это звук победы. Надя смотрит на экраны: Теплостанция работает, Медпункт стоит пустой, Клуб и Теплица в идеальном порядке, все системы зеленые.
        -> ending_3_star_part_2
}
-> END

// =======================================================
// СЕКЦИЯ 4: ДИАЛОГИ, СОБЫТИЯ И КОНЦОВКИ
// Здесь лежат все "самостоятельные" сцены.
// Игра попадает сюда по команде -> из других узлов
// и так же по команде -> возвращается обратно.
// =======================================================

=== intro_1 ===
#Location: Поселок-1
# clear
(Панорама футуристического, но уютного поселка. В архитектуре угадываются мотивы берлог, но сквозь метель видны огоньки автоматических дронов-помощников и контуры обтекаемых аэромобилей, припаркованных у домов.)

2125 год. Планета Берлога. Здесь, в гармонии высоких технологий и суровой северной природы, процветает цивилизация разумных медведей.

Но даже в мире летающих дирижаблей и энергомеда древние инстинкты берут свое. Каждую зиму, когда холода становятся слишком сильными, все взрослые медведи погружаются в Великую Зимнюю Спячку, доверяя поддержание жизни в поселке своим детям-подросткам.

+ [Далее...]
    -> intro_2a

=== intro_2a ===
#Location: Sledopytovy
# clear

В центре нашего поселка - три семьи, следующие разным Традициям.

СЛЕДОПЫТОВЫ, из Традиции Первопроходцев. Их девиз — "Всегда вперед!". Подросток Надя — их достойная дочь: спортивная, ответственная и готовая к любым вызовам. А вот малыш Андрейка (названный в честь дяди Бруса!) понимает девиз по-своему, "прокладывая путь" к внутренностям любой техники со словами "оно само сломалось!".

+ [Далее...]
    // Переходим к следующей семье
    -> intro_2b

=== intro_2b ===
#Location: Voskoboynikovy
# clear

 ВОСКОБОЙНИКОВЫ, из Традидии Конструкторов. Но их сын Артем — "белая ворона" в семье. Его сердце принадлежит не механизмам, а биологии и его экспериментальным персикам в теплице. А его сестрички-близняшки Соня и Тоня — главный источник работы для медпункта, ведь они умудряются найти приключения на ровном месте.

+ [Далее...]
    // Переходим к последней семье
    -> intro_2c

=== intro_2c ===
#Location: Gladkovy
# clear

ГЛАДКОВЫ, из Традиции Биоинженеров-медиков. Их родители — адепты ЗОЖа, но подростки Игнат и Маша предпочитают лыжам и пробежкам код и паяльник. Игнат — блестящий программист, а Маша — гениальный инженер. Этот дуэт может починить все. За ними приглядывает тихий малыш Кирилка, который больше всего на свете любит агрономию и свои "апельсинчики" в теплице.

+ [Далее...]
    // После рассказа о всех семьях переходим к следующей части вступления
    -> intro_3

=== intro_3 ===
#Location: Кризисный центр зеленый
# clear

(Диспетчерская поселка. На столе рядом с экранами терминалов лежит значок Первопроходца.)

Пока взрослые спят, подростки несут "Снежную вахту" — поочередно дежурят в поселковом кризис-центре, следя за системами.

Сегодня очередь Нади. Для нее это не просто дежурство. Это шанс доказать, что она достойна своей Традиции. Шанс показать, что на нее можно положиться в самой сложной ситуации.

+ [Далее...]
    -> intro_4

=== intro_4 ===
#Location: Кризисный центр красный
# clear

(Та же комната, но за окном бушует метель, а на голографическом проекторе мигает красная иконка "СБОЙ СИСТЕМЫ".)

Этой ночью буран оказался сильнее, чем предсказывали все симуляторы. Надя проснулась от воя сирены. Тревожный сигнал с Теплостанции. Отказ генератора. Обрыв связи с Медпунком.

Спасательная служба уже в пути, но их дирижабль сможет пробиться сквозь бурю не раньше, чем через восемь часов.

Испытание, о котором она думала, оказалось куда серьезнее, чем она могла себе представить.

+ [Собрать всех на экстренную видеосвязь]
    // Теперь мы переходим к старому диалогу-конференции,
    // который теперь будет звучать гораздо осмысленнее.
    -> initial_briefing


=== initial_briefing ===
#Location: Экран
(Сигнал видеосвязи устанавливается. На экране появляются окошки с сонными, но решительными мордами подростков)
Надя: Так, все на связи? Отлично. Сводка, как вы знаете, неутешительная. Буран отрезал нас от внешнего мира, все взрослые в Спячке. Спасатели будут через восемь часов.

Артем: Восемь часов... Надя, Теплостанция не работает. Мы долго не протянем. Три часа — и весь поселок вымерзнет.  А еще... я только что осматривал Соню и Тоню. Они в порядке, но если с ними что-то случится, наш Медпункт тоже обесточен. #П

Игнат: Обесточен — это мягко сказано. Генератор в хлам. Мы с Машей можем его починить, но нам нужны запчасти со Склада. Руками мы их не дотащим. #З

Маша: Не ворчи, Игнат. Мы справимся! Надя, Артем, вы же у нас логисты. Если вы сможете организовать доставку деталей со Склада, мы с братом починим все, что угодно, буквально в тот же час!

Игнат: Починим-то мы починим. Но вы забыли про нашего главного вредителя! Я про Андрейку. Оставить его без присмотра — это как запустить вирус в систему. Он не просто ломает что-то от скуки. Он же 'улучшает'! И в первую очередь его тянет к тому, что уже работает! #З

Артем: Он прав. В прошлом году он так 'улучшил' наш пищевой синтезатор, что тот начал печатать только горькую капусту. И это после того, как папа его только-только наладил. #П

Надя: Вот это и есть наш план. Слушайте все. Распределяем роли: Игнат, Маша — вы наши инженеры. Ваша задача — чинить. Сидите наготове и сообщайте, что вам нужно. Без вас мы просто замерзнем.
Надя: Артем — ты наш медик. Главная задача — следить за двойняшками. Если они получат травму, только ты сможешь им помочь в работающем Медпункте. Ну и... сможешь помогать с доставкой, если будет свободная минутка.
Надя: Я беру на себя общую координацию и основную логистику. Я или Артем будем доставлять запчасти инженерам, чтобы они не тратили время. Помните, мы команда. Каждое наше действие на счету. Вопросы есть?
Артем: Доставить запчасти, положим, мы с тобой сможем. Но весь Поселок занесен снегом. Если не использовать шнекороторы, то инженеры с их тяжелым оборудованием не проберутся ни до Медпункта, ни до Теплостанции.
Маша: Верно! У нас три шнекоротора, в каждом домике есть свой. По одной соседней зоне за час смогут очистить! #Р
Игнат: (ворчливо) Почистить-то смогут, но сразу разрядятся... Нужно, чтобы был свободный путь до Станции зарядки, иначе они все станут бесполезны... Артем, она там рядом с вашим домом.
Надя: Хорошо, значит, первым делом почистим проход к ней.

+ [Нет, вот теперь всё предельно ясно. Пора за работу!]
    -> all_clear
+ [Маша: У меня вопрос про малышей. Что с ними делать?]
    -> about_kids

= all_clear
    Игнат: Вот и отлично. Давайте уже начинать, пока у меня тут все окончательно не заиндевело. #З
    -> end_of_briefing

= about_kids
    Надя: Хороший вопрос. За ними нужно постоянно присматривать. Игнат, Маша, Кирилка на вас. Артем, двойняшки на тебе. Я присмотрю за Андрейкой. Но это отнимает время... возможно, позже мы придумаем что-то получше.
    -> end_of_briefing

= end_of_briefing
+ [Начнем]
 #Location: Карта
    -> main_game_loop

=== kirillka_hijack_dialogue ===
#Location: Кризисный центр красный
# clear
Надя: (просматривает отчет с камер наблюдения. Внезапно она останавливает запись и увеличивает изображение. Глубокие следы от гусениц шнекоротора уводят от Дома Гладковых, но по очень странной траектории) Так, я не поняла. Кто-то брал шнекоротор 'C' без моего ведома? Игнат, Маша, доложите обстановку! #З

Игнат: (слышен тяжелый вздох Игната) Это Кирилка. Опять. Мы его отвлекли, но он все-таки рванул к Теплице, а мы прошляпили. Говорит, что его 'экспериментальные морозоустойчивые апельсины' без него погибнут. #П

Кирилка: Ну Надя! Надя, скажи им, там же мои апельсинчики! Маша-а, Игна-а-а-т! Ну пустите же! #З

Маша: Он просто одержим этой идеей. Мы пытались объяснить, что это опасно, но он никого не слушает. Считает, что только он может их спасти. #У

Надя: Ясно. Нужно что-то решать.

+ [Это недопустимо. Техника и системы жизнеобеспечения важнее апельсинов. Изолировать его.]
    Надя: Игнат, Маша, я понимаю его мотивы, но мы не можем рисковать техникой. Это наш единственный шанс на выживание. Пожалуйста, проследите, чтобы он больше не выходил из дома. Никаких самовольных действий. #З
    Игнат: Давно пора. Будет сделано. #З
    ~ kirillka_hijack_dialogue_seen = true
    -> end_of_dialogue

+ [Погодите. А что если в его словах есть смысл? Артем, подключись.]
    Надя: Стойте. Не рубите с плеча. Артем, ты на связи? Ты у нас биолог. В том, что говорит Кирилка, есть какой-то смысл? Растениям действительно может требоваться особый уход в такой мороз?
    Артем: Ну... вообще-то да. Если это какие-то редкие гибриды, резкий перепад температур может запустить необратимые процессы. Он не совсем бредит. Конечно, это не оправдывает угон техники, но его беспокойство... оно обосновано. #У
    Надя: Вот как... Значит, если мы найдем способ доставить его в Теплицу безопасно, он может оказаться там полезен. Хорошо, я поняла.
    ~ kirillka_hijack_dialogue_seen = true
    ~ kirillka_greenhouse_option_unlocked = true
    -> end_of_dialogue

= end_of_dialogue
-> main_game_loop

=== club_unlock_dialogue ===
#Location: Клуб
# clear
Маша: Есть! Шнекоротор пробился! Путь к Клубу расчищен! Я вижу его, он целый! #Р

Надя: Отличная работа, команда! Это меняет всё. Теперь у нас есть безопасное место, куда можно отправить малышей, чтобы они не путались под лапами и не искали приключений. #Р

Артем: Наконец-то. Я уже начал переживать за Соню и Тоню. Значит, если девочки будут здоровы, я смогу их туда отвести, а потом окончательно забыть о беспокойстве за них? #Р

Надя: Именно. Каждый из нас теперь может сопроводить 'своего' малыша в Клуб. Да, это займет время, но зато потом они будут в безопасности. И там есть, чем заняться этим непоседам. Это наш главный козырь против хаоса.

Маша: Погоди... Я вижу тут старый ремонтный дрон. Он сломан, конечно... Но знаешь, малыши обожают возиться с такими штуками. Если бы мы принесли сюда один комплект запчастей, они бы точно нашли, чем заняться. #У

Надя: Хм... Занять их делом, которое еще и пользу принесет? #У
Надя: Это отличная мысль! Хорошо, команда, принимаем к сведению: если будет возможность, нужно доставить одну запчасть в Клуб. Это может решить сразу две проблемы. #Р

+ [Отлично. Принять к сведению.]
    ~ club_unlocked_dialogue_seen = true
    -> main_game_loop

=== kirillka_bored_dialogue ===
# clear
Маша: Надя, у нас тут... дипломатический кризис. Кирилка в Клубе сидеть отказывается. Говорит, что тут нет ничего 'для серьезных агрономов' и что ему здесь скучно. #У

Игнат: Пусть не выдумывает! Делом бы лучше занялся! Вон тут сколько роботов, дрона-ремонтника пусть чинит! #З

Кирилка: Я и хочу делом! Только настоящим! Мои апельсинчики в Теплице без меня не выживут! Там нужен особый уход! #З

Надя: (вздыхает) Так, проблему поняла. Что же нам с ним сделать...

+ [Сказать, чтобы не выдумывал. Дисциплина прежде всего.]
    Надя: Маша, скажите ему, чтобы сидел тихо. Сейчас не до капризов и не до апельсинов. Пусть там ну хоть просто посидит с ребятами, хотя бы не будет доставлять проблем. #З
    ~ kirillka_bored_dialogue_seen = true
    -> return_from_bored_dialogue

+ [Расспросить его. Может, он в чем-то прав?]
    Надя: Погоди, Игнат. А что если он прав? 
    Кирилка: Ура! Да-да-да, я прав, сто тыщ раз прав! Я позабочусь о них, ну пожалуйста-пожалуйста! #Р 
    Надя: Артем, ты у нас во всех этих апельсинах разбираешься. Не напортачит он там? #У
    Артем: Сложно сказать, не видя его 'апельсинчиков'. Но он действительно разбирается в агрономии, и в работающей Теплице от него будет больше пользы, чем в Клубе, где он сидит из-под палки. #У 
    Артем: И знаешь что еще... Агродрон в Теплице ведь тоже сломан. Если мы доставим туда запчасти, Кирилка сможет с ним разобраться. Это его любимая игрушка, он с детства его схемы изучал. #Р
    Надя: Вот как... То есть, мы можем спасти эти его апельсины и заодно починить ценное оборудование? Хорошо. Это риск, но, возможно, оправданный. Даю добро на агро-практику! #Р
    ~ kirillka_bored_dialogue_seen = true
    ~ kirillka_greenhouse_option_unlocked = true
    -> return_from_bored_dialogue

= return_from_bored_dialogue
-> main_game_loop

=== first_mischief_dialogue ===
#Location: Кризисный центр красный
# clear

{ andreyka_activity == "naughty":
    Игнат: Надя, прием! У нас тут ЧП! Андрейка только что попытался 'проапгрейдить' шнекоротор с помощью лома! Еле отогнали! #З

- else:
    { sonya_tonya_activity == "naughty":
        Артем: Надя, срочно! Соня с Тоней решили поиграть в 'покорителей севера' на крыше! Я их загнал домой, но они обе травмированы! #П
    
    - else:
        { kirillka_activity == "naughty": // <-- ДОБАВЛЕНО ЯВНОЕ УСЛОВИЕ
            Игнат: Надя, он это сделал! Кирилка угнал шнекоротор! Следы ведут в сторону Теплицы. Говорит, что-то про свои апельсины! #У
        }
    }
}

Надя: (на секунду прикрывает глаза лапой) Поняла... Я боялась, что до этого дойдет. Сидеть без дела — не для них. Они найдут себе приключения, и добром это не кончится. #П

+ [Нужно за ними постоянно следить!]
    Надя: Верно. Это отнимет у нас кучу времени, но безопасность важнее. Я могу потратить свое время, чтобы присмотреть за Андрейкой. Артем, ты за Соней и Тоней. Игнат, Маша, Кирилка на вас. Это должно их занять на какое-то время.
    -> continue_game_after_dialogue

+ [Может, есть способ получше? Изолировать их?]
    Маша: Есть идея. Если мы сможем расчистить завал к Клубу, его можно использовать как большую игровую комнату. Там полно интересных конструкторов и голо-симуляторов. Им будет чем заняться, и они будут в безопасности. #Р
    Надя: Отличная мысль! Это становится приоритетной задачей. Но пока мы до него не добрались, придется кому-то из нас тратить время на присмотр. #Р
    -> continue_game_after_dialogue

= continue_game_after_dialogue
-> report_phase.check_expansion_event

=== scene_initiate_club_repair ===
#Location: Клуб
# clear
(Когда логист входит в Клуб с ящиком запчастей, видно, что малыши столпились вокруг сломанного ремонтного дрона и с огромным любопытством его разглядывают.)
Маша: (по рации) О, ты как раз вовремя! Они от него не отходят. Говорят, что знают, как его починить. #У

Надя: (вполголоса) Они уверены? Это не игрушка... С другой стороны, если у них получится, это будет огромная помощь.

+ [Оставить им запчасть. Пусть попробуют!]
    Надя: Хорошо, Маша. Оставляю детали здесь. Пусть действуют, но под вашим с Игнатом присмотром! #Р
    ~ club_drone_repair_authorized = true
    ~ club_repair_dialogue_seen = true
    -> player_actions_phase.check_greenhouse_trigger

+ [Нет, это слишком опасно. Вернуть запчасть.]
    Надя: Не сейчас. Слишком большой риск. Нужно вернуть запчасть обратно на склад.
    ~ parts_at_club = parts_at_club - 1
    ~ parts_at_warehouse = parts_at_warehouse + 1
    ~ club_repair_dialogue_seen = true
    -> player_actions_phase.check_greenhouse_trigger

=== scene_initiate_greenhouse_repair ===
#Location: Теплица
# clear
(Когда логист доставляет запчасть в Теплицу, видно, что Кирилка уже вовсю изучает агродрона, подключив к нему свой планшет).
Кирилка: Я почти нашел причину поломки! Мне не хватает только одного силового реле... О, это оно?!

Артем: Погоди, Кирилка! Ты уверен, что справишься? Это сложная система. #У

Кирилка: Уверен! Я уже год его схемы изучаю! Ну давайте же, я смогу! #Р

+ [Хорошо, вот запчасть. Действуй!]
    Артем: Ладно, верю в тебя. Но будь предельно осторожен, у нас мало запчастей! #У
    ~ greenhouse_drone_repair_authorized = true
    ~ greenhouse_repair_dialogue_seen = true
    -> player_actions_phase.process_logistics_actions

+ [Прости, но нет. Слишком рискованно.]
    Надя: Извини, малыш. Сейчас не время для экспериментов. Нужно вернуть деталь на склад. #П
    ~ parts_at_greenhouse = parts_at_greenhouse - 1
    ~ parts_at_warehouse = parts_at_warehouse + 1
    ~ greenhouse_repair_dialogue_seen = true
    -> player_actions_phase.process_logistics_actions

=== ending_1_star_part_2 ===
#Location: Центральная площадь
# clear
Огромный спасательный дирижабль приземляется на центральной площади. Из него выходит капитан — молодой, но уже опытный медведь в форме спасательной службы. Он всего на пару зим старше ее. Он осматривает потрепанный, но не сломленный поселок и подходит к измотанной Наде.
Капитан: Тяжелая была вахта, Следопытова?
Надя: Очень, капитан. #П
Капитан: Но вы устояли. И все живы. Это главное. Сдавай пост, коллега. Вы заслужили отдых. #Р
Надя: (кивает, чувствуя, как с плеч падает невероятный груз. Они выжили. Сами.)
Статус победы: выживание, 1 звезда! Надя справилась с задачей, поздравляем!
-> END

=== ending_2_star_part_2 ===
#Location: Центральная площадь
# clear
(Капитан спасателей получает отчет от своего помощника, такого же подростка в форме.) Помощник: Паша... Ой, простите, капитан! Странная ситуация — нас вызывали на помощь, большинство систем было выведено из строя, но... кажется, вахтенные многое смогли наладить. Дети в безопасности, заняты делом, критические системы все в порядке. #У
Капитан: (уважительно кивает Наде) Не просто выживали, значит? Сумели наладить порядок в хаосе. Сильная заявка, Следопытова. Это была достойная вахта. #Р
Надя: (позволяет себе слабую улыбку.) Это было больше, чем просто выживание! #Р
Статус победы: стабилизация, 2 звезды! Надя безусловно справилась со своей вахтой и смогла очень многое наладить. Она не ошиблась с выбором Традиции, Первопроходцев, и в будущем сможет взяьб на себя еще более сложные задачи. Поздравляем!
-> END

=== ending_3_star_part_2 ===
#Location: Центральная площадь
# clear
(Капитан спасателей обходит поселок с нескрываемым уважением во взгляде. Он видит работающие дроны, слышит смех малышей из Клуба и чувствует тепло, идущее от Теплостанции. Капитан подходит к четверым подросткам, которые стоят, уставшие, но гордые.)
Капитан: Я думал, нас вызвали на катастрофу... А у вас тут почти образцовый порядок! Так держать! Про вашу вахту точно будут рассказывать на инструктажах. Это не просто стандарт выживания. Это стандарт, к которому теперь другим придется тянуться. #Р
Надя: (оглядывая Артема, Игната и Машу) Мы сделали это вместе, ребята! #Р
Статус победы: все цели достигнуты, 3 звезды. О Наде Следопытовой расскажут в новостях, а ее победу над стихией и хаосом станут приводить в пример другим медвежатам-подросткам. Капитан Буран прав, её опыт станет основой для тренировок будущих ответственных за такие вахты. Поздравляем с успехом!
-> END

// =======================================================
// ФУНКЦИИ-ПОМОЩНИКИ
// =======================================================

=== function task_to_russian(task_name) ===
{
    - task_name == "none":
        ~ return "свободен."
    - task_name == "deliver_part_to_8":
        ~ return "Доставка запчасти на Теплостанцию (8)."
    - task_name == "deliver_part_to_5":
        ~ return "Доставка запчасти в Медпункт (5)."
    - task_name == "deliver_part_to_4":
        ~ return "Доставка запчасти в Теплицу (4)."
    - task_name == "deliver_part_to_3":
        ~ return "Доставка запчасти в Клуб (3)."
    - task_name == "deliver_part_to_shnek_A":
        ~ return "Доставка запчасти для Шнекоротора А (7)."
    - task_name == "deliver_part_to_shnek_B":
        ~ return "Доставка запчасти для Шнекоротора B (2)."
    - task_name == "deliver_part_to_shnek_C":
        ~ return "Доставка запчасти для Шнекоротора C (9)."
    - task_name == "babysit_andreyka":
        ~ return "присмотр за Андрейкой."
    - task_name == "babysit_sonya_tonya":
        ~ return "присмотр за Соней и Тоней."
    - task_name == "babysit_kirillka":
        ~ return "присмотр за Кирилкой."
    - task_name == "escort_andreyka_to_club":
        ~ return "сопровождение Андрейки в Клуб (3)."
    - task_name == "escort_sonya_tonya_to_club":
        ~ return "сопровождение Сони и Тони в Клуб (3)."
    - task_name == "escort_kirillka_to_club":
        ~ return "сопровождение Кирилки в Клуб (3)."
    - task_name == "escort_kirillka_to_greenhouse":
        ~ return "сопровождение Кирилки в Теплицу (4)."
    - task_name == "heal":
        ~ return "лечение больных в Медпункте (5)."
    - task_name == "fix_heat_station":
        ~ return "ремонт Теплостанции (8)."
    - task_name == "fix_med_point":
        ~ return "ремонт Медпункта (5)."
    - task_name == "fix_greenhouse":
        ~ return "ремонт Теплицы (4)."
    - task_name == "fix_shnek_A":
        ~ return "ремонт Шнекоротора А (7)."
    - task_name == "fix_shnek_B":
        ~ return "ремонт Шнекоротора B (2)."
    - task_name == "fix_shnek_C":
        ~ return "ремонт Шнекоротора C (9)."
    - else:
        // Для задач шнекороторов, которые имеют вид "expand_X_to_Y"
        ~ return "расчистка снежного завала."
}


