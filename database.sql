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
    name VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    password_hash VARCHAR(511) NOT NULL,
    role VARCHAR(255) NOT NULL,
    teaching_group_id BIGINT REFERENCES teaching_groups(id),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    CHECK (
        role = 'Student' OR
        role = 'Teacher' OR
        role = 'Admin'
    )
);

CREATE TABLE blogs (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id) NOT NULL,
    name VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    status blog_statuses NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE programs (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC NOT NULL,
    program_type VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE modules (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP
);

CREATE TABLE courses (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP
);

CREATE TABLE lessons (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    video_url VARCHAR(255),
    position INTEGER,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    course_id BIGINT REFERENCES courses(id),
    deleted_at TIMESTAMP
);

CREATE TABLE quizzes (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT REFERENCES lessons(id) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    content JSONB NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE exercises (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT REFERENCES lessons(id) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    url VARCHAR(1023) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE discussions (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT REFERENCES lessons(id) UNIQUE NOT NULL,
    user_id BIGINT REFERENCES users(id) NOT NULL,
    text JSONB NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE enrollments (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id) NOT NULL,
    program_id BIGINT REFERENCES programs(id) NOT NULL,
    status enrollment_statuses NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE payments (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    enrollment_id BIGINT REFERENCES enrollments(id) NOT NULL,
    amount NUMERIC NOT NULL,
    status payment_statuses NOT NULL,
    paid_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE program_completions (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id) NOT NULL,
    program_id BIGINT REFERENCES programs(id) NOT NULL,
    status program_completion_statuses NOT NULL,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE certificates (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id) NOT NULL,
    program_id BIGINT REFERENCES programs(id) NOT NULL,
    url VARCHAR(1023) UNIQUE NOT NULL,
    issued_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE program_modules (
    program_id BIGINT REFERENCES programs(id),
    module_id BIGINT REFERENCES modules(id),
    PRIMARY KEY (program_id, module_id)
);

CREATE TABLE course_modules (
    module_id BIGINT REFERENCES modules(id),
    course_id BIGINT REFERENCES courses(id),
    PRIMARY KEY (module_id, course_id)
);
