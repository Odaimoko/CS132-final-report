classdef  testUI_total< matlab.uitest.TestCase
    properties
        UI_clerk;
        UI_Customer;
        UI_ATM;
        
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            addpath('..\src');
            addpath('..\src\datastructure');
            addpath('..\ui');
            testCase.UI_clerk = UI_Clerk_exported;
            testCase.UI_Customer = UI_Customer_exported;
            testCase.UI_ATM = UI_ATM_exported;
            
        end
    end
    methods (Test)
        function test_createAccount_normal(testCase)
            testCase.press(testCase.UI_clerk.open_account);
            testCase.type(testCase.UI_clerk.Identity_Input, 123);
            testCase.type(testCase.UI_clerk.PW_Input,'123');
            testCase.press(testCase.UI_clerk.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            id = card_id;
            testCase.verifyEqual(testCase.UI_clerk.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            
            testCase.press(testCase.UI_clerk.deposit);
            testCase.type(testCase.UI_clerk.Account_Input, card_id);

            testCase.type(testCase.UI_clerk.Amount_Input,100);
            testCase.press(testCase.UI_clerk.Confirm_deposit_money);
            testCase.verifyEqual(testCase.UI_clerk.Message_Feedback.Text, ['Money added successfully']);
            
            testCase.press(testCase.UI_Customer.request_ticket);
%             testCase.type(testCase.UI_Customer.Identity_Input, 123);
%             testCase.type(testCase.UI_Customer.PW_Input,'123');
            testCase.press(testCase.UI_Customer.Confirm_open_account);

            testCase.type(testCase.UI_ATM.Account_Input, id);
            testCase.type(testCase.UI_ATM.PW_Input,'123');
            testCase.press(testCase.UI_ATM.Confirm_check_password);
 
        end
        
        
    end
    
end