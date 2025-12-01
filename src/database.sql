CREATE TABLE programs (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    program_name VARCHAR(255) NOT NULL,
    price NUMERIC NOT NULL,
    program_type: VARCHAR(255) NOT NULL,
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
    order INT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    course_id BIGINT REFERENCES courses(id) NOT NULL,
    is_deleted BOOLEAN DEFAULT false
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
