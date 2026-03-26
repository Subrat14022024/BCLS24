namespace FSO_Purchase.VendorItemColor;

table 58400 "Vendor Item Color"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50000; Code; Code[100])
        {
            DataClassification = CustomerContent;
            OptimizeForTextSearch = true;
            ToolTip = 'Specifies Vendor Item Color';
        }
    }
}