table 50101 "Shop Payment Entries"
{
    Caption = 'Shop Payment Entries';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', FRA = 'N° séquence';
        }
        field(5; "Type"; Option)
        {
            OptionCaptionML = ENU = 'Payment, G/L Account', FRA = 'Payement,Compte Général';
            OptionMembers = "Payment","G/L Account";
        }
        field(6; "Date"; Date)
        {
            CaptionML = ENU = 'Date', FRA = 'Date';
        }
        field(7; "Location Code"; Code[10])
        {
            CaptionML = ENU = 'Location Code', FRA = 'Code magasin';
            TableRelation = Location.Code;
        }
        field(8; "Subsidiary Code"; Code[10])
        {
            CaptionML = ENU = 'Subsidiary code', FRA = 'Code filiale';
            //TableRelation = PFSubsidiary.Code;
        }
        field(10; "Tender Type"; Code[10])
        {
            CaptionML = ENU = 'Tender type', FRA = 'Type de payement';
            TableRelation = "LSC Tender Type Setup".Code;
        }
        field(11; "Tender Subtype"; Code[10])
        {
            CaptionML = ENU = 'Tender subtype', FRA = 'Subtype de payement';
            TableRelation = "LSC Tender Type Card Setup"."Card No." where("Tender Type Code" = field("Tender Type"));
        }
        field(12; "G/L Account No."; Code[20])
        {
            CaptionML = ENU = 'G/L account no.', FRA = 'N° compte général';
            TableRelation = "G/L Account"."No.";

        }
        field(15; "Total Amount Transactions"; Decimal)
        {
            CaptionML = ENU = 'Total amount transactions', FRA = 'Montant total des transactions';
        }
        field(20; "Exported to Sales Subs."; Boolean)
        {
            CaptionML = ENU = 'Exported to sales subsidiary', NLB = 'Exporté aux ventes filiale';
        }
        field(21; "Synchronization Date Export"; Date)
        {
            CaptionML = ENU = 'Synchronization date export', FRA = 'Date synchronisation exportée';
        }
        field(22; "Synchronization Time Export"; Time)
        {
            CaptionML = ENU = 'Synchronization time export', FRA = 'Heure synchronisation exportée';
        }
        field(23; "Synchronization Date Import"; Date)
        {
            CaptionML = ENU = 'Synchronization date import', FRA = 'Date synchronisation importée';
        }
        field(24; "Synchronization Time Import"; Time)
        {
            CaptionML = ENU = 'Synchronization time import', FRA = 'Heure synchronisation importée';
        }
        field(30; "Gen. Journal Template"; Code[10])
        {
            CaptionML = ENU = 'Gen. journal template', FRA = 'Modèle feuille comptabilité';
            TableRelation = "Gen. Journal Template".Name;
        }
        field(31; "Gen. Journal Batch"; Code[10])
        {
            CaptionML = ENU = 'Gen. journal batch', FRA = 'Nom feuille comptabilité';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = field("Gen. Journal Template"));
        }
        field(32; "Gen. Journal Line No."; Integer)
        {
            CaptionML = ENU = 'Gen. journal line no.', FRA = 'N° ligne feuille comptabilité';
        }
        field(33; "Gen. Journal Amount"; Decimal)
        {
            CaptionML = ENU = 'Gen. journal amount', FRA = 'Montant feuille comptabilité';
        }
        field(40; Processed; Boolean)
        {
            CaptionML = ENU = 'Processed', FRA = 'Traite';
        }
        field(41; Posted; Boolean)
        {
            CaptionML = ENU = 'Posted', FRA = 'Enregistré';
        }
        field(50; "Invoice No."; Code[20])
        {
            CaptionML = ENU = 'Invoice No.', FRB = 'N° facture;NLB=Factuurnr.';
        }
        field(60; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(61; "Type of Posting"; Option)
        {
            Caption = 'Type of Posting';
            OptionCaptionML = ENU = 'DagAfsluiting,Kluis';
            OptionMembers = DagAfsluiting,Kluis;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
