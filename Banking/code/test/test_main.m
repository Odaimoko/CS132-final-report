classdef test_main < matlab.uitest.TestCase
    properties
        App
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            addpath('..\src');
            addpath('..\src\datastructure');
            addpath('..\ui');
            testCase.App = UI_Clerk_exported;
            
            testCase.addTeardown(@delete,testCase.App);
        end
    end
    methods (Test)
        function test_OpenAccount_normal(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            
        end
        function test_OpenAccount_duplicate(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
        end
        function test_OpenAccount_missPwd(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.press(testCase.App.Confirm_open_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Password cannot be emtpy');
        end
        function test_OpenAccount_missAccount(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.PW_Input, '123');
            testCase.press(testCase.App.Confirm_open_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Id cannot be emtpy');
        end
%         function test_OpenAccount_minusAccount(testCase)
%             testCase.press(testCase.App.open_account);
%             testCase.type(testCase.App.Identity_Input, -123);
%             testCase.type(testCase.App.PW_Input, '123');
%             testCase.press(testCase.App.Confirm_open_account);
%             testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Account added Failed');
%         end
%         function test_OpenAccount_minusPwd(testCase)
%             testCase.press(testCase.App.open_account);
%             testCase.type(testCase.App.Identity_Input, 123);
%             testCase.type(testCase.App.PW_Input, '-123');
%             testCase.press(testCase.App.Confirm_open_account);
%             testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Account added Failed');
%         end

        function test_CloseAccount_normal(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            % Close accout above
            testCase.press(testCase.App.close_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.type(testCase.App.Account_Input,card_id);
            testCase.press(testCase.App.Confirm_close_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account removed successfully.']);
            
        end
        function test_CloseAccount_WNum(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            % Close accout above
            testCase.press(testCase.App.close_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.type(testCase.App.Account_Input,card_id+1);
            testCase.press(testCase.App.Confirm_close_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account removed Failed']);
        end
        
        function test_CloseAccount_WAccount(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            % Close accout above
            testCase.press(testCase.App.close_account);
            testCase.type(testCase.App.Identity_Input, 123+unidrnd(1000));
            testCase.type(testCase.App.PW_Input,'123');
            testCase.type(testCase.App.Account_Input,card_id);
            testCase.press(testCase.App.Confirm_close_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Account removed Failed');
        end
        
        function test_CloseAccount_WPwd(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            % Close accout above
            testCase.press(testCase.App.close_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123456');
            testCase.type(testCase.App.Account_Input,card_id);
            testCase.press(testCase.App.Confirm_close_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Account removed Failed');
        end
        
        function test_CloseAccount_missAccount(testCase)
            testCase.press(testCase.App.close_account);
            testCase.type(testCase.App.PW_Input, '123');
            testCase.type(testCase.App.Account_Input,1);
            testCase.press(testCase.App.Confirm_close_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Id cannot be emtpy');
        end
        function test_CloseAccount_missPwd(testCase)
            testCase.press(testCase.App.close_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.Account_Input,1);
            testCase.press(testCase.App.Confirm_close_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Password cannot be emtpy');
        end
        
        function test_Deposit_normal(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            id = card_id;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            
            testCase.press(testCase.App.deposit);
            testCase.type(testCase.App.Account_Input, card_id);

            testCase.type(testCase.App.Amount_Input,100);
            testCase.press(testCase.App.Confirm_deposit_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money added successfully']);
        end
        
        function test_Deposit_WAccount(testCase)
            testCase.press(testCase.App.deposit);
            testCase.type(testCase.App.Account_Input, 10000);
            testCase.type(testCase.App.Amount_Input,100);
            testCase.press(testCase.App.Confirm_deposit_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money add failed']);
        end
        
        function test_Deposit_WAmount(testCase)
            testCase.press(testCase.App.deposit);
            testCase.type(testCase.App.Account_Input, 1);
            testCase.type(testCase.App.Amount_Input,-1);
            testCase.press(testCase.App.Confirm_deposit_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Amount invalid']);
        end
        
        function test_Deposit_AbAmcount(testCase)
            testCase.press(testCase.App.deposit);
            testCase.type(testCase.App.Amount_Input,-1);
            testCase.press(testCase.App.Confirm_deposit_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account cannot be emtpy']);
        end
        
        function obj = test_Withdraw_normal(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            
            testCase.press(testCase.App.deposit);
            testCase.type(testCase.App.Account_Input, card_id);
            testCase.type(testCase.App.Amount_Input,100);
            testCase.press(testCase.App.Confirm_deposit_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money added successfully']);
            
            % withdraw
            testCase.press(testCase.App.withdraw);
            testCase.type(testCase.App.Account_Input,card_id);
            testCase.type(testCase.App.Amount_Input,100);
            testCase.press(testCase.App.Confirm_withdraw_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money withdrawn successfully']);
            
        end
        
        function test_Withdraw_Acced(testCase)
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            % withdraw
            testCase.press(testCase.App.withdraw);
            testCase.type(testCase.App.Account_Input, card_id);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.type(testCase.App.Amount_Input,1000);
            testCase.press(testCase.App.Confirm_withdraw_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money withdrawn failed']);
            
        end
        
        function test_Withdraw_Minus(testCase)
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            % withdraw
            testCase.press(testCase.App.withdraw);
            testCase.type(testCase.App.Account_Input, card_id);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.type(testCase.App.Amount_Input,-4);
            testCase.press(testCase.App.Confirm_withdraw_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Amount invalid']);
            
        end
        
        function test_Transfer_normal(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            id = card_id;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            
            testCase.press(testCase.App.deposit);
            testCase.type(testCase.App.Account_Input, card_id);
            testCase.type(testCase.App.Amount_Input,100);
            testCase.press(testCase.App.Confirm_deposit_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money added successfully']);
            
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            to_id = card_id;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
        
            testCase.press(testCase.App.transfer);
            testCase.type(testCase.App.Account_Input, id);
            testCase.type(testCase.App.To_Account_Input, to_id);
            testCase.type(testCase.App.Amount_Input, 100);
            testCase.type(testCase.App.PW_Input, '123');
            testCase.press(testCase.App.Confirm_transfer);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money transfered successfully']);
        end
        
        function test_changePwd_normal(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            id = card_id;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
 

            testCase.press(testCase.App.change_password);
            testCase.type(testCase.App.Account_Input, id);
            testCase.type(testCase.App.PW_Input, '123');
            testCase.type(testCase.App.New_PW_Input, '456');
            
            testCase.press(testCase.App.Confirm_change_pw);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Password changed successfully.']);
        end
        
        function test_ATM_normal(testCase)
            UI_ATM = UI_ATM_exported;
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            id = card_id;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            
            testCase.press(testCase.App.deposit);
            testCase.type(testCase.App.Account_Input, card_id);

            testCase.type(testCase.App.Amount_Input,100);
            testCase.press(testCase.App.Confirm_deposit_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money added successfully']);

            testCase.type(UI_ATM.Account_Input, id);
            testCase.type(UI_ATM.PW_Input,'123');
            testCase.press(UI_ATM.Confirm_check_password);
            
            testCase.press(UI_ATM.deposit);
            testCase.type(UI_ATM.Account_Input, id);
            testCase.type(UI_ATM.Amount_Input,100);
            testCase.press(UI_ATM.Confirm_deposit_money);
            
            testCase.press(UI_ATM.withdraw);
            testCase.type(UI_ATM.Account_Input, id);
            testCase.type(UI_ATM.PW_Input, '123');
            
            testCase.type(UI_ATM.Amount_Input,100);
            testCase.press(UI_ATM.Confirm_withdraw_money);
            
            
 
        end
        
    end
    
end