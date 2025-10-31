window.FSOItemCarousel = {
    container: null,
    currentIndex: 0,
    images: [],

    SetImages: function (imageUrls) {
        this.images = imageUrls || [];
        this.currentIndex = 0;
        this.render();
    },

    render: function () {
        if (!this.container) {
            this.container = document.currentScript.parentElement;
        }
        this.container.innerHTML = "";

        if (this.images.length === 0) {
            this.container.innerHTML = "<p style='text-align:center;'>No Images</p>";
            return;
        }

        var img = document.createElement("img");
        img.src = this.images[this.currentIndex];
        img.style.maxWidth = "100%";
        img.style.maxHeight = "100%";
        img.style.display = "block";
        img.style.margin = "0 auto";

        img.onclick = () => {
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod(
                "OnImageClicked",
                [this.images[this.currentIndex]]
            );
        };

        var prevBtn = document.createElement("button");
        prevBtn.innerHTML = "⟨";
        prevBtn.style.float = "left";
        prevBtn.onclick = () => {
            this.currentIndex =
                (this.currentIndex - 1 + this.images.length) % this.images.length;
            this.render();
        };

        var nextBtn = document.createElement("button");
        nextBtn.innerHTML = "⟩";
        nextBtn.style.float = "right";
        nextBtn.onclick = () => {
            this.currentIndex = (this.currentIndex + 1) % this.images.length;
            this.render();
        };

        this.container.appendChild(prevBtn);
        this.container.appendChild(img);
        this.container.appendChild(nextBtn);
    }
}
