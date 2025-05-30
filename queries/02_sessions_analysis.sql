-- Анализ игровых сессий пользователей (таблица: skygame.game_sessions)

-- Цели:
-- 1. Изучить динамику количества игровых сессий
-- 2. Оценить качество сессий (по длительности)
-- 3. Выделить "длинные" сессии (> 1 часа)
-- 4. Сделать выводы об активности и вовлечённости пользователей

------------------------------------------------------------

-- 1. Количество сессий и доля качественных (дольше 5 минут)
SELECT 
    DATE_TRUNC('month', start_session) AS month,
    COUNT(*) AS total_sessions,  -- общее количество сессий
    SUM(CASE 
        WHEN end_session - start_session > INTERVAL '5 minutes' THEN 1 
        ELSE 0 END) AS long_sessions,
    SUM(CASE 
        WHEN end_session - start_session > INTERVAL '5 minutes' THEN 1 
        ELSE 0 END)::FLOAT / COUNT(*) AS share_long_sessions
FROM skygame.game_sessions
GROUP BY month
ORDER BY month;

-- Вывод: начиная с января 2023 года наблюдается рост как количества, так и доли "длинных" сессий

------------------------------------------------------------

-- 2. Средняя длительность сессий по месяцам (фильтр: > 5 минут)
SELECT 
    DATE_TRUNC('month', start_session) AS month,
    AVG(end_session - start_session) AS avg_session_duration
FROM skygame.game_sessions
WHERE end_session - start_session > INTERVAL '5 minutes'
GROUP BY month
ORDER BY month;

-- Вывод: продолжительность сессий увеличивается, особенно в начале 2023 года

------------------------------------------------------------

-- 3. Доля сессий, превышающих 1 час (в рамках "качественных")
SELECT 
    DATE_TRUNC('month', start_session) AS month,
    SUM(CASE 
        WHEN end_session - start_session > INTERVAL '1 hour' THEN 1 
        ELSE 0 END) AS ultra_long_sessions,
    SUM(CASE 
        WHEN end_session - start_session > INTERVAL '1 hour' THEN 1 
        ELSE 0 END)::FLOAT / COUNT(*) AS share_ultra_long_sessions
FROM skygame.game_sessions
WHERE end_session - start_session > INTERVAL '5 minutes'
GROUP BY month
ORDER BY month;

-- Вывод: в 2023 году доля "очень длинных" сессий стабильно держится в пределах 65%–70%

------------------------------------------------------------

-- Общий вывод по игровым сессиям:

-- • Наблюдается устойчивая положительная динамика роста количества сессий, начиная с января 2023 года.
-- • Доля "длинных" сессий (> 5 минут) стабильно увеличивается, что говорит об улучшении вовлечённости.
-- • Сессии длительностью более 1 часа составляют значительную долю — до 70% от качественных.
-- Это говорит о высокой вовлечённости игроков и вероятной ценности игрового контента.