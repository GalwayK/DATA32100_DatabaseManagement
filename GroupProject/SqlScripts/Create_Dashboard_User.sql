// Create a user named Dashboard. Give the user read permissions on the views.

CREATE USER 
    Dashboard 
IDENTIFIED BY   
    DashboardViewUser32100;
    
// Create User Role 

CREATE ROLE dashboard_view_user;
    
GRANT CONNECT TO dashboard_view_user; 

// Create Task Role 

CREATE ROLE 
    read_datamart_views;
    
GRANT SELECT ON datamart.donations_date_view TO read_datamart_views;

GRANT SELECT ON datamart.donations_volunteers_view TO read_datamart_views;

GRANT SELECT ON datamart.donations_hierarchy_view TO read_datamart_views;

// Assign Task Role to User Role

GRANT read_datamart_views TO dashboard_view_user; 

// Assign User Role to User

GRANT dashboard_view_user TO Dashboard;


