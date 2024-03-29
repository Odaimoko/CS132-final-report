classdef testCustomerAPP < matlab.uitest.TestCase
    properties
        App
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            addpath('..');
            db = Database();
            testCase.App = CustomerUI;
            testCase.App.setDatabase(db);
            testCase.addTeardown(@delete,testCase.App);
        end
    end
    methods (Test)
        
        function test_MenuButtonPushed(testCase)
            % State: No category menu is selected
            % Input: Press Menu1_1 button and Press Menu2_1 button 
            % Expected Output: The brands of products in the corresponding menu display.
           
            testCase.press(testCase.App.Menu1_1);
            brands = testCase.getBrandsFromDB(testCase.App.Menu1_1.Text);
            for i = 1:length(brands)
                item = eval(['testCase.App.item',num2str(i)]);
                testCase.verifyEqual(item.Text, char(brands(i)));
            end

            pause(1);
            
            
            testCase.press(testCase.App.Menu2_2);
            brands = testCase.getBrandsFromDB(testCase.App.Menu2_2.Text);
            for i = 1:length(brands)
                item = eval(['testCase.App.item',num2str(i)]);
                testCase.verifyEqual(item.Text, char(brands(i)));
            end
            pause(2); 
        end
        
        function test_ItemButtonPushed(testCase)
            % State: No item button in the current menu is selected
            % Input: Press the item1 button 
            % Expected Output: The thumbnail of the goods corresponding to the item1 button display.
            testCase.press(testCase.App.Menu1_1);
            pause(1);
            testCase.press(testCase.App.item1);
            pause(2);
            imgSc = testCase.getImageSource(testCase.App.item1.Text);
            testCase.verifyEqual(testCase.App.Image.ImageSource,imgSc);
        end

    
        function test_SingleItemPlusButtonPushed(testCase)
            % State: No item1 in the payment table.
            % Input: Press the item1_plus button 
            % Expected Output: The item1 is added to the payment table.
            testCase.press(testCase.App.Menu1_1);
            pause(1);
            testCase.press(testCase.App.item1_plus);
            pause(2);
            testCase.verifyEqual(testCase.App.UITable.Data(1,:),table("多芬",1,13));
        end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
        function test_SingleItemMinusButtonPushed(testCase)
            % State: one item1 in the payment table.
            % Input: Press the item1_minus button 
            % Expected Output: The item1 is not in the payment table.
            testCase.press(testCase.App.Menu1_1);
            pause(1);
            testCase.press(testCase.App.item1_plus);
            pause(1);
            testCase.press(testCase.App.item1_minus);
            pause(2);
            testCase.verifyEqual(isempty(testCase.App.UITable.Data),true);
        end
        
        function test_SingleItemPlusMultiTimesButtonPushed(testCase)
            % State: No item1 in the payment table， the number of item1 is 10.
            % Input: Press the item1_plus button 15 times
            % Expected Output: The number of the items in the payment UItable is 10.
            Var2 = testCase.getRemainNum('多芬');
            Var3 = 13*Var2;
            testCase.press(testCase.App.Menu1_1);
            pause(1);
            for i = 1:15
                testCase.press(testCase.App.item1_plus);
            end
            
            pause(2);
            testCase.verifyEqual(testCase.App.UITable.Data(1,:),table("多芬",Var2,Var3));
            
        end
        
        
        function test_MultiItemPlusButtonPushed(testCase)
            % State: No item in the payment table.
            % Input: Press the item1_plus button in Menu1_1 once,
            %        Press the itme2_plus button in Menu2_1 twice.
            %        Press the item2_plus button in Menu1_2 three times.
            % Expected Output: The items display correctly in the payment table.
            testCase.press(testCase.App.Menu1_1);
            testCase.press(testCase.App.item1_plus);
            pause(1);
            testCase.press(testCase.App.Menu2_1);
            testCase.press(testCase.App.item2_plus);
            testCase.press(testCase.App.item2_plus);
            pause(1);
            testCase.press(testCase.App.Menu1_2);
            testCase.press(testCase.App.item2_plus);
            testCase.press(testCase.App.item2_plus);
            testCase.press(testCase.App.item2_plus);
            pause(1);
            testCase.verifyEqual(testCase.App.UITable.Data(1,:),table("多芬",1,13));
            testCase.verifyEqual(testCase.App.UITable.Data(2,:),table("飘柔",2,30));
            testCase.verifyEqual(testCase.App.UITable.Data(3,:),table("可比克",3,9));
        end

        function test_MultiItemMinusButtonPushed(testCase)
            % State: 1 item1 Menu1_1, 2 itme2 in Menu2_1 .3 item2 in
            %        Menu1_2 are added to the payment table.
            % Input: Press the item1_minus button in Menu1_1 once,
            %        Press the itme2_minus button in Menu2_1 once.
            %        Press the item2_minus button in Menu1_2 once.
            % Expected Output: The items display correctly in the payment table.
            testCase.press(testCase.App.Menu1_1);
            testCase.press(testCase.App.item1_plus);
            testCase.press(testCase.App.Menu2_1);
            testCase.press(testCase.App.item2_plus);
            testCase.press(testCase.App.item2_plus);
            testCase.press(testCase.App.Menu1_2);
            testCase.press(testCase.App.item2_plus);
            testCase.press(testCase.App.item2_plus);
            testCase.press(testCase.App.item2_plus);
            pause(1.5);

            testCase.press(testCase.App.Menu1_2);
            testCase.press(testCase.App.item2_minus);
            pause(1.5);
            testCase.press(testCase.App.Menu2_1);
            testCase.press(testCase.App.item2_minus);
            pause(1.5);
            testCase.press(testCase.App.Menu1_1);
            testCase.press(testCase.App.item1_minus);
            
            testCase.verifyEqual(testCase.App.UITable.Data(1,:),table("飘柔",1,15));
            testCase.verifyEqual(testCase.App.UITable.Data(2,:),table("可比克",2,6));
        end

         
        function test_CheckOutButton(testCase)
            % State: One item1 in Menu1_1 and one item2 in Menu2_2 are added to the table.
            % Input: Press the PayButton
            % Expected Output: The items in the payment table are deducted
            % in the database, the  payment table is flushed and PaySuccess
            % text displays, the number of the item deducts from the database.
            remainNum1 = testCase.getRemainNum('多芬');
            remainNum2 = testCase.getRemainNum('好吃点');
            testCase.press(testCase.App.Menu1_1);
            testCase.press(testCase.App.item1_plus);
            pause(1);
            testCase.press(testCase.App.Menu2_2);
            testCase.press(testCase.App.item2_plus);
            pause(1);
            testCase.press(testCase.App.PayButton);
            pause(5);
            testCase.verifyEqual(testCase.App.PaySuccess.Text,'支付成功！点击继续下次购物');
            testCase.verifyEqual(testCase.getRemainNum('多芬'),remainNum1 - 1);
            testCase.verifyEqual(testCase.getRemainNum('好吃点'),remainNum2 - 1);
        end
        
        function test_PrintTicket(testCase)
            % State: One item1 in Menu1_1 and one item2 in Menu2_2 are
            % added to the table, and pay success.
            % Input: Press the Printer button.
            % Expected Output: The information of the items displays
            % correctly in the ticket.
            testCase.press(testCase.App.Menu1_1);
            testCase.press(testCase.App.item1_plus);
            pause(1);
            testCase.press(testCase.App.Menu2_2);
            testCase.press(testCase.App.item2_plus);
            pause(1);
            testCase.press(testCase.App.PayButton);
            testCase.press(testCase.App.Printer);
            ticket = testCase.App.getTicket();
            Var1 = ["多芬";"好吃点"];
            Var2 = [1;1];
            Var3 = [13;5];
            testCase.verifyEqual(ticket,table(Var1,Var2,Var3));
        end

    end
    methods 
        function brand_list = getBrandsFromDB(testCase,typeName)
            db = testCase.App.getDatabase();
            brand_list = [];
            for i = 1:db.getGoodsNum()
                goods = db.getGoods(i);
                if strcmp(goods.type, typeName)
                    brand_list = [brand_list, goods.getBrand()];
                end
            end
        end
        
       function imgSc = getImageSource(testCase,brandName)
            db = testCase.App.getDatabase();
            imgSc = '';
            for i = 1:db.getGoodsNum()
                goods = db.getGoods(i);
                if strcmp(goods.brand, brandName)
                    imgSc = goods.img_src;
                    return
                end
            end
       end
       
       function num = getRemainNum(testCase,brandName)
           db = testCase.App.getDatabase();
           num = 0;
           for i = 1:db.getGoodsNum()
               goods = db.getGoods(i);
               if strcmp(goods.brand, brandName)
                   num = goods.remain_num;
                   return
               end
           end
       end
        
    end
    

    
end