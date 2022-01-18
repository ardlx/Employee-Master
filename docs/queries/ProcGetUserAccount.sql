IF OBJECT_ID ('dbo.ProcGetUserAccount') IS NOT NULL
	DROP PROCEDURE dbo.ProcGetUserAccount
GO

CREATE PROCEDURE ProcGetUserAccount(

	@employeecode VARCHAR(7)

)

AS

BEGIN

	BEGIN TRY
   	
        IF  (EXISTS(SELECT EmployeeCode FROM UserControl WHERE EmployeeCode = @employeecode))
        
        	BEGIN
        		SELECT UserControl.UserLevel, UserControl.Username, UserControl.Password,
        		EmployeeInformationView.* FROM UserControl INNER JOIN EmployeeInformationView
        		ON UserControl.EmployeeCode = EmployeeInformationView.EmployeeCode
        		WHERE UserControl.Username = @employeecode
        		AND UserControl.DeletedDate IS NULL
        	END
        
        ELSE
        
        	BEGIN
				SELECT 0 AS UserLevel, EmployeeInformationView.* FROM EmployeeInformationView
				WHERE EmployeeInformationView.EmployeeCode = @employeecode

        	END
	
	END TRY
	
	--catch the error
	BEGIN CATCH
		SELECT 404 AS Results
	END CATCH

END







GO

