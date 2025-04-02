-- Chèn dữ liệu vào bảng roles nếu chưa tồn tại
INSERT INTO roles (name)
SELECT 'ROLE_USER' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM roles WHERE name = 'ROLE_USER');

INSERT INTO roles (name)
SELECT 'ROLE_ADMIN' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM roles WHERE name = 'ROLE_ADMIN');

-- Chèn dữ liệu vào bảng permissions nếu chưa tồn tại
INSERT INTO permissions (name)
SELECT 'READ_PRIVILEGE' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'READ_PRIVILEGE');

INSERT INTO permissions (name)
SELECT 'WRITE_PRIVILEGE' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'WRITE_PRIVILEGE');

INSERT INTO permissions (name)
SELECT 'DELETE_PRIVILEGE' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'DELETE_PRIVILEGE');

-- Chèn dữ liệu vào bảng users nếu chưa tồn tại
INSERT INTO users (username, email, password, enabled)
SELECT 'user1', 'user1@example.com', '$2a$10$OVqmrx1zrXVt6hVhLIcGtu.TXf62QXqun295VegJIRhw9SPjkjJ2y', 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'user1');

INSERT INTO users (username, email, password, enabled)
SELECT 'admin', 'admin@example.com', '$2a$10$OVqmrx1zrXVt6hVhLIcGtu.TXf62QXqun295VegJIRhw9SPjkjJ2y', 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin');

-- Gán roles cho users nếu chưa tồn tại
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id FROM users u, roles r
WHERE u.username = 'user1' AND r.name = 'ROLE_USER'
  AND NOT EXISTS (SELECT 1 FROM user_roles ur WHERE ur.user_id = u.id AND ur.role_id = r.id);

INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id FROM users u, roles r
WHERE u.username = 'admin' AND r.name = 'ROLE_ADMIN'
  AND NOT EXISTS (SELECT 1 FROM user_roles ur WHERE ur.user_id = u.id AND ur.role_id = r.id);

-- Gán permissions cho roles nếu chưa tồn tại
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p
WHERE r.name = 'ROLE_USER' AND p.name = 'READ_PRIVILEGE'
  AND NOT EXISTS (SELECT 1 FROM role_permissions rp WHERE rp.role_id = r.id AND rp.permission_id = p.id);

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p
WHERE r.name = 'ROLE_ADMIN' AND p.name = 'READ_PRIVILEGE'
  AND NOT EXISTS (SELECT 1 FROM role_permissions rp WHERE rp.role_id = r.id AND rp.permission_id = p.id);

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p
WHERE r.name = 'ROLE_ADMIN' AND p.name = 'WRITE_PRIVILEGE'
  AND NOT EXISTS (SELECT 1 FROM role_permissions rp WHERE rp.role_id = r.id AND rp.permission_id = p.id);

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p
WHERE r.name = 'ROLE_ADMIN' AND p.name = 'DELETE_PRIVILEGE'
  AND NOT EXISTS (SELECT 1 FROM role_permissions rp WHERE rp.role_id = r.id AND rp.permission_id = p.id);
