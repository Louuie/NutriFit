import { Response } from "express";


export const defaultRoute = (res: Response) => {
    res.json({app_name: 'NutriFit'});
}