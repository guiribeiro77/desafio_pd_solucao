import express from 'express';
import { addSquad, listSquads } from '../controllers/squadController.js';

const router = express.Router();

router.post('/', addSquad);   // Cadastrar Squad
router.get('/', listSquads);  // Listar Squads

export default router;
