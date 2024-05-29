import express from 'express';
import { searchForItem } from './routes/search';
import { defaultRoute } from './routes/default';
import dotenv from 'dotenv';
const app = express();
dotenv.config();
const port = process.env.port || 3000;

app.get('/', defaultRoute);     

app.get('/search', searchForItem);

app.listen(port);