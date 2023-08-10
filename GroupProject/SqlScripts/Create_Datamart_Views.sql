CREATE OR REPLACE VIEW datamart.donations_date_view 
AS SELECT do.donation_id FROM 
    datamart.donation do
INNER JOIN  
    datamart.donation_date ti
ON 
    ti.date_id = do.date_id;
    
CREATE OR REPLACE view datamart.donations_hierarchy_view
AS SELECT do.address_id 
FROM 
    datamart.address ad
INNER JOIN 
    datamart.donation do
ON 
    ad.address_id = do.address_id;
    
CREATE OR REPLACE view datamart.donations_volunteers_view
AS SELECT do.volunteer_id
FROM 
    datamart.donation do 
INNER JOIN 
    datamart.volunteer vo 
ON 
    vo.volunteer_id = do.volunteer_id;