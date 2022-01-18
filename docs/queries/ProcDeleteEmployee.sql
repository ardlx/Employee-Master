IF OBJECT_ID ('dbo.ProcDeleteEmployee') IS NOT NULL
	DROP PROCEDURE dbo.ProcDeleteEmployee
GO

CREATE PROCEDURE ProcDeleteEmployee
    (	
		@employeecode VARCHAR(7)
    )
AS

BEGIN

	-- declaring variables
	DECLARE @results VARCHAR(255), @deleted DATETIME
	
	-- try catch error
	BEGIN TRY
		SET @deleted = (SELECT DeletedDate FROM Employees WHERE EmployeeCode = @employeecode)
        IF  (@deleted IS NULL)
        			
        	BEGIN
        		UPDATE Employees
					SET DeletedDate = getdate()
					WHERE EmployeeCode = @employeecode

        						
            	SET @results = 1
            END 
        ELSE
            BEGIN
            
        		UPDATE Employees
					SET DeletedDate = NULL
					WHERE EmployeeCode = @employeecode						
						
            	SET @results = 0
        	END
 	 END TRY
     
     --catch the error
     BEGIN CATCH
 		SET @results = 404
     END CATCH
     
	 -- return the message of query
	 SELECT @results AS Results
END



GO

