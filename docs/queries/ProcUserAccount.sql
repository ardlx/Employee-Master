IF OBJECT_ID ('dbo.ProcUserAccount') IS NOT NULL
	DROP PROCEDURE dbo.ProcUserAccount
GO

CREATE PROCEDURE ProcUserAccount
    (	
		@employeecode VARCHAR(7),
		@username VARCHAR(20),
		@fullname VARCHAR(50),
		@password VARCHAR(50),
		@ipaddr VARCHAR(15),
		@userlevel NUMERIC(1,0),
		@createddate DATETIME,
		@updateddate DATETIME,
		@updateduserid VARCHAR(7),
		@option BIT
    )
AS

BEGIN

	-- declaring variables
	DECLARE @results VARCHAR(255)
	
	-- try catch error
	BEGIN TRY
	
		--Insert / Update
		IF @option = 1
	        IF  (EXISTS(SELECT * FROM UserControl WHERE EmployeeCode = @employeecode))
	        			
	        	BEGIN
	        	
					UPDATE UserControl SET Username = @username, Fullname = @fullname, Password = @password, 
						IPAddr = @ipaddr, UserLevel = @userlevel, CreatedDate = @createddate, 
						UpdatedDate = @updateddate, UpdatedUserId = @updateduserid
						WHERE EmployeeCode = @employeecode
	        						
	            	SET @results = 1
	            END 
	        ELSE
	            BEGIN
	            
					INSERT INTO UserControl
						(EmployeeCode, Username, Fullname, Password, IPAddr, UserLevel, CreatedDate,
						UpdatedDate, UpdatedUserId)
						VALUES (@employeecode, @username, @fullname, @password, @ipaddr,
						@userlevel,  @createddate, @updateddate, @updateduserid)
					
	            	SET @results = 0
            	
        		END
		
		--Delete
		ELSE
		
			IF (EXISTS(SELECT * FROM UserControl WHERE EmployeeCode = @employeecode AND DeletedDate IS NULL))
				
				BEGIN
					UPDATE UserControl SET DeletedDate = getdate(),
						UpdatedUserId = @updateduserid
						WHERE EmployeeCode = @employeecode
				END
				
			ELSE
				
				BEGIN
					UPDATE UserControl SET DeletedDate = NULL,
						UpdatedUserId = @updateduserid
						WHERE EmployeeCode = @employeecode
				END
		
			
        	SET @results = 1
	END TRY
	
	--catch the error
	BEGIN CATCH
		SET @results = 404
	END CATCH
	
	-- return the message of query
	SELECT @results AS Results
END




GO

