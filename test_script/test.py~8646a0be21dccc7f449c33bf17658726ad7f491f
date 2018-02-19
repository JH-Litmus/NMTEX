import  win32com.client

excel = win32com.client.Dispatch("Excel.Application")
excel.Visible = True
wb = excel.Workbooks.Open('D:\\Documents\\NMTEX\\lib\\test11.xlsx')
ws = wb.ActiveSheet

for i in range(1,10):
    print(ws.Cells(i,1).Value)
excel.Quit()
