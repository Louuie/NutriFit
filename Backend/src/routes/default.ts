import { Request, Response } from 'express';


export const defaultRoute = (req: Request, res: Response) => {
    res.json({app_name: 'NutriFit'});
}
