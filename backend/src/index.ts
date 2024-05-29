import express, { Request, Response } from 'express';
import { searchForItem } from './routes/search';
import dotenv from 'dotenv';
const app = express();
dotenv.config();
const port = process.env.port || 3000;

app.get('/', (req: Request, res: Response) => {
    res.json(
        {
        name: 'NutriFit'
        }
    )
})

app.get('/search', searchForItem);

app.listen(port, () => {
    console.log(`NutriFit Backend now running on ${port}`);
})
