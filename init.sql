CREATE TABLE IF NOT EXISTS processed_tasks (
    id SERIAL PRIMARY KEY,
    task_data TEXT,
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
