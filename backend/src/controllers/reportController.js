import {
    createReport,
    getHoursBySquadAndPeriod,
    getTotalHoursBySquadAndPeriod,
    getAverageHoursBySquadAndPeriod
  } from '../models/reportModel.js';
  
  export const addReport = (req, res) => {
    const { description, employeeId, spentHours } = req.body;
  
    if (!description || !employeeId || !spentHours) {
      return res.status(400).json({ error: 'Informe description, employeeId e spentHours' });
    }
  
    createReport(description, employeeId, spentHours, (err, report) => {
      if (err) {
        console.error('Erro ao criar report:', err);
        return res.status(500).json({ error: 'Erro ao criar report' });
      }
      res.status(201).json(report);
    });
  };
 
  export const getSquadHours = (req, res) => {
    const { squadId, startDate, endDate } = req.query;
    if (!squadId || !startDate || !endDate)
      return res.status(400).json({ error: 'Informe squadId, startDate e endDate' });
  
    getHoursBySquadAndPeriod(squadId, startDate, endDate, (err, results) => {
      if (err) return res.status(500).json({ error: 'Erro interno' });
      res.json(results);
    });
  };
  

  export const getTotalSquadHours = (req, res) => {
    const { squadId, startDate, endDate } = req.query;
    if (!squadId || !startDate || !endDate)
      return res.status(400).json({ error: 'Informe squadId, startDate e endDate' });
  
    getTotalHoursBySquadAndPeriod(squadId, startDate, endDate, (err, result) => {
      if (err) return res.status(500).json({ error: 'Erro interno' });
      res.json({ squadId, totalHours: result.totalHours });
    });
  };
  
  export const getAverageSquadHours = (req, res) => {
    const { squadId, startDate, endDate } = req.query;
    if (!squadId || !startDate || !endDate)
      return res.status(400).json({ error: 'Informe squadId, startDate e endDate' });
  
    getAverageHoursBySquadAndPeriod(squadId, startDate, endDate, (err, result) => {
      if (err) return res.status(500).json({ error: 'Erro interno' });
      res.json({
        squadId,
        averagePerDay: Number(result.average.toFixed(2))
      });
    });
  };
  