-- Add daily and weekly goals to users table
ALTER TABLE users ADD COLUMN daily_calorie_goal REAL DEFAULT NULL;
ALTER TABLE users ADD COLUMN weekly_workout_goal INTEGER DEFAULT NULL;
ALTER TABLE users ADD COLUMN preferred_dark_mode INTEGER DEFAULT 0; -- 0 = light, 1 = dark

-- Create table for tracking goal achievements
CREATE TABLE IF NOT EXISTS goal_achievements (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  goal_type TEXT NOT NULL, -- 'daily_calorie', 'weekly_workout'
  achievement_date DATE NOT NULL,
  goal_value REAL NOT NULL,
  achieved_value REAL NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_goal_achievements_user_date ON goal_achievements(user_id, achievement_date);
CREATE INDEX IF NOT EXISTS idx_goal_achievements_type ON goal_achievements(goal_type);

