-- Get users and last logged on
SELECT l.name,
	u.email,
	COALESCE(u.modified_on,u.created_on) as last_modified
FROM user_login l
JOIN users u
ON l.id=u.login_id
ORDER BY u.modified_on DESC;
