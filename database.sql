CREATE TYPE enrollment_statuses AS ENUM (
    'active',
    'pending',
    'cancelled',
    'completed'
);

CREATE TYPE payment_statuses AS ENUM (
    'pending',
    'failed',
    'paid',
    'refunded'
);

CREATE TYPE program_completion_statuses AS ENUM (
    'active',
    'completed',
    'pending',
    'cancelled'
);

CREATE TYPE blog_statuses AS ENUM (
    'created',
    'in moderation',
    'published',
    'archived'
);

CREATE TABLE teaching_groups (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    slug VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE users (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nickname VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    password_hash VARCHAR(511) NOT NULL,
    user_type VARCHAR(255) NOT NULL,
    teaching_group_id BIGINT REFERENCES teaching_groups(id),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CHECK (
        user_type = 'Student' OR
        user_type = 'Teacher' OR
        user_type = 'Admin'
    )
);

CREATE TABLE blogs (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id) NOT NULL,
    heading VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    blog_status blog_statuses NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE programs (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    program_name VARCHAR(255) NOT NULL,
    price NUMERIC NOT NULL,
    program_type VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CHECK (program_type = 'intensive' OR  program_type = 'profession')
);

CREATE TABLE modules (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    module_name VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    is_deleted BOOLEAN DEFAULT false
);

CREATE TABLE courses (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    course_name VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    is_deleted BOOLEAN DEFAULT false
);

CREATE TABLE lessons (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_name VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    video_url VARCHAR(255),
    sort_order INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    course_id BIGINT REFERENCES courses(id) NOT NULL,
    is_deleted BOOLEAN DEFAULT false
);

CREATE TABLE quizzes (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT REFERENCES lessons(id) UNIQUE NOT NULL,
    quizz_name VARCHAR(255) NOT NULL,
    content JSONB NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE exercises (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT REFERENCES lessons(id) UNIQUE NOT NULL,
    exercise_name VARCHAR(255) NOT NULL,
    exercise_url VARCHAR(1023) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE discussions (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT REFERENCES lessons(id) UNIQUE NOT NULL,
    comments JSONB NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE enrollments (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id) NOT NULL,
    program_id BIGINT REFERENCES programs(id) NOT NULL,
    enrollment_status enrollment_statuses NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE payments (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    enrollment_id BIGINT REFERENCES enrollments(id) NOT NULL,
    sum NUMERIC NOT NULL,
    payment_status payment_statuses NOT NULL,
    paid_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE program_completions (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id) NOT NULL,
    program_id BIGINT REFERENCES programs(id) NOT NULL,
    program_completion_status program_completion_statuses NOT NULL,
    started_at TIMESTAMP,
    finished_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE certificates (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id) NOT NULL,
    program_id BIGINT REFERENCES programs(id) NOT NULL,
    certificate_url VARCHAR(1023) UNIQUE NOT NULL,
    issued_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE program_modules (
    program_id BIGINT REFERENCES programs(id),
    module_id BIGINT REFERENCES modules(id),
    PRIMARY KEY (program_id, module_id)
);

CREATE TABLE module_courses (
    module_id BIGINT REFERENCES modules(id),
    course_id BIGINT REFERENCES courses(id),
    PRIMARY KEY (module_id, course_id)
);
