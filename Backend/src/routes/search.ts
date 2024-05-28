import { Request, Response } from 'express';
import axios from 'axios';


interface Nutrient {
    nutrientName?: string,
    value: number,
    unit: string | undefined,
    unitName?: string,
}

interface NutrientObject {
    [key: string]: Nutrient,
}

export const searchForItem = async (req: Request, res: Response) => {
    axios.get(`https://api.nal.usda.gov/fdc/v1/foods/search?api_key=${process.env.USDA_API_KEY}&query=${req.query.upc}`).then((USDA_SEARCH_RESULT) => {
        // Create a food_nutrients object
        const nutrientObject: NutrientObject = {};
        USDA_SEARCH_RESULT.data.foods[0].foodNutrients.map((result: Nutrient) => {
            nutrientObject[result.nutrientName as string] = {
                value: result.value,
                unit: result.unitName
            };
        });
        let searchResult = {
            name: USDA_SEARCH_RESULT.data.foods[0].description,
            food_nutrients: nutrientObject,
        }
        res.json(searchResult);
    }).catch((err) => res.status(500).json(err))
}

