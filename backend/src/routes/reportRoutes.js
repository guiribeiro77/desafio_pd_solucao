import express from 'express';
import { addReport, getSquadHours, getTotalSquadHours, getAverageSquadHours} from '../controllers/reportController.js';

const router = express.Router();

router.post('/', addReport);   // Cadastrar relatorio
router.get('/squad-hours', getSquadHours);
router.get('/squad-total', getTotalSquadHours);
router.get('/squad-average', getAverageSquadHours);


export default router;
