controladdin "FSO Item Image Carousel"
{
    RequestedHeight = 300;
    RequestedWidth = 400;
    MinimumHeight = 150;
    MinimumWidth = 200;
    VerticalStretch = true;
    HorizontalStretch = true;

    Scripts = 'FSOItemCarousel.js';
    StartupScript = 'FSOItemCarousel.js';
    //StyleSheets = 'FSOItemCarousel.css';

    procedure SetImages(ImageUrls: Text);

    event OnImageClicked(ImageUrl: Text);

}
