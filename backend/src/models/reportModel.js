import db from '../config/db.js';

export const createReport = (description, employeeId, spentHours, callback) => {
  const sql = 'INSERT INTO reports (description, employeeId, spentHours) VALUES (?,?,?)';
  db.query(sql, [description, employeeId, spentHours], (err, result) => {
    if (err) return callback(err, null);
    callback(null, { id: result.insertId, description, employeeId, spentHours });
  });
};

export const getAllReports = (callback) => {
  const sql = 'SELECT * FROM reports';
  db.query(sql, (err, results) => {
    if (err) return callback(err, null);
    callback(null, results);
  });
};

export const getHoursBySquadAndPeriod = (squadId, startDate, endDate, callback) => {
  const start = `${startDate} 00:00:00`;
  const end = `${endDate} 23:59:59`;

  const sql = `
    SELECT 
      e.id AS employeeId, 
      e.name AS employeeName,
      r.description,
      COALESCE(r.spentHours, 0) AS totalSpentHours
    FROM employees e
    LEFT JOIN reports r 
      ON e.id = r.employeeId
      AND r.createdAt BETWEEN ? AND ?
    WHERE e.squadId = ?
    ORDER BY e.name ASC, r.createdAt DESC;
  `;

  db.query(sql, [start, end, squadId], (err, results) => {
    if (err) return callback(err, null);
    callback(null, results);
  });
};


export const getTotalHoursBySquadAndPeriod = (squadId, startDate, endDate, callback) => {
  const start = `${startDate} 00:00:00`;
  const end = `${endDate} 23:59:59`;

  const sql = `
    SELECT COALESCE(SUM(r.spentHours), 0) AS totalHours
    FROM reports r
    INNER JOIN employees e ON r.employeeId = e.id
    WHERE e.squadId = ?
      AND r.createdAt BETWEEN ? AND ?;
  `;

  db.query(sql, [squadId, start, end], (err, results) => {
    if (err) return callback(err, null);
    callback(null, results[0]); // results[0].totalHours
  });
};

export const getAverageHoursBySquadAndPeriod = (squadId, startDate, endDate, callback) => {
  const start = `${startDate} 00:00:00`;
  const end = `${endDate} 23:59:59`;

  const sql = `
    SELECT COALESCE(SUM(r.spentHours), 0) AS totalHours
    FROM reports r
    INNER JOIN employees e ON r.employeeId = e.id
    WHERE e.squadId = ?
      AND r.createdAt BETWEEN ? AND ?;
  `;

  db.query(sql, [squadId, start, end], (err, results) => {
    if (err) return callback(err, null);

    const totalHours = results[0].totalHours;
    const startDateObj = new Date(startDate);
    const endDateObj = new Date(endDate);
    const diffDays = Math.max(1, Math.ceil((endDateObj - startDateObj) / (1000 * 60 * 60 * 24)));
    const average = totalHours / diffDays;

    callback(null, { totalHours, diffDays, average });
  });
};
