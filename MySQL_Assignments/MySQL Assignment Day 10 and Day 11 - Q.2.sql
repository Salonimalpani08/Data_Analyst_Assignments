# Day 10
-- Create the view products status. Show year wise total products sold. Also find the percentage of total value for each year.

-- Reference

CREATE
	ALGORITHM = UNDEFINED
    DEFINER = `root`@`localhost`
    SQL SECURITY DEFINER
VIEW `products_status` AS
    SELECT
        YEAR(`o` . `orderDate`) AS `year`,
        COUNT(`od` . `quantityOrdered`) AS `sales`
	FROM
        (`orders` `o`
        JOIN `orderdetails` `od` ON ((`o`. `orderNumber` = `od`.`orderNumber`)))
	GROUP BY `year`
    ORDER BY `year`

-- Output

CREATE
    ALGORITHM = UNDEFINED
    DEFINER = `root`@`localhost`
    SQL SECURITY DEFINER
VIEW `products_status` AS
    SELECT
         `products_status`.`year` AS `year`,
		`products_status`.`sales` AS `sales`,
         ((`products_status`.`sales` / (SELECT
                 SUM(`products_status`.`sales`)
		 FROM
             `products_status`
		 WHERE
              (`products_status`.`year` = `products_status`.`year`))) * 100 ) AS `percentage_of_sales`
		 FROM
             `products_status`
		 GROUP BY `products_status`.`year`
         ORDER BY `products_status`.`sales` DESC


# Day 11
-- 2)Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. 
-- Format the total amount to nearest thousand unit (K).
-- Tables: Customers, Payments

CREATE DEFINER = `root`@`localhost` PROCEDURE `Get_country_payments` (IN input_year INT, In input_country VARCHAR(255))
BEGIN
     SELECT
         YEAR(paymentdate) AS year,
         country,
         CONCAT(format (sum(amount)/1000 , 0 ), 'K' ) AS totalamount
     FROM
         Payments
     JOIN Customers ON Payments.customernumber = Customers.customernumber
     WHERE
         YEAR(paymentdate) = Input_year
         AND country = input_country
     GROUP BY
		 paymentdate, country ;
END
