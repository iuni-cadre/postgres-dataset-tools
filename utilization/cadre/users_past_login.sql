-- Get users and last logged on
SELECT l.name,
	u.email,
	u.modified_on
FROM user_login l
JOIN users u
ON l.id=u.login_id
WHERE u.modified_on IS NOT NULL
ORDER BY u.modified_on DESC;