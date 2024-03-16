ji<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1" name="viewport">
    <title>Flutter Web App</title>
    <script>
        // Function to send message to Flutter app
        function sendMessageToFlutter(message) {
            window.parent.postMessage(message, '*');
        }

        // Add event listener for beforeunload event (browser close/refresh)
        window.addEventListener('beforeunload', function (event) {
            // Send message to Flutter app indicating browser close/refresh
            sendMessageToFlutter('beforeunload');
        });

        // Add event listener for click event on refresh button
        window.addEventListener('unload', function (event) {
            if (event.clientY < 0) {
                sendMessageToFlutter('refresh');
            }
        });

        // Add event listener for click event on close button
        window.addEventListener('beforeunload', function (event) {
            if (event.clientY < 0) {
                sendMessageToFlutter('close');
            }
        });
    </script>
</head>

<body>
    <!-- Entry point for Flutter app -->
    <div id="flutter-app-container"></div>
    <script src="main.dart.js" type="application/javascript"></script>
</body>

</html>


new 

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1" name="viewport">
    <title>Flutter Web App</title>
    <script>
        // Function to send message to Flutter app
        function sendMessageToFlutter(message) {
            window.parent.postMessage(message, '*');
        }

        // Add event listener for beforeunload event (browser close/refresh)
        window.addEventListener('beforeunload', function (event) {
            // Send message to Flutter app indicating browser close/refresh
            sendMessageToFlutter('beforeunload');
        });

        // Add event listener for click event on refresh button
        window.addEventListener('load', function (event) {
            if (performance.navigation.type === 1) {
                sendMessageToFlutter('refresh');
            }
        });

        // Add event listener for click event on close button
        window.addEventListener('unload', function (event) {
            sendMessageToFlutter('close');
        });
    </script>
</head>

<body>
    <!-- Entry point for Flutter app -->
    <div id="flutter-app-container"></div>
    <script src="main.dart.js" type="application/javascript"></script>
</body>

</html>
new file 


<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1" name="viewport">
    <title>Flutter Web App</title>
    <script>
        var isRefreshed = false;

        // Function to send message to Flutter app
        function sendMessageToFlutter(message) {
            window.parent.postMessage(message, '*');
        }

        // Add event listener for beforeunload event (browser close/refresh)
        window.addEventListener('beforeunload', function (event) {
            // Send message to Flutter app indicating browser close/refresh
            sendMessageToFlutter('beforeunload');
            // Set flag to indicate the page is being refreshed or closed
            isRefreshed = true;
        });

        // Add event listener for unload event (page close)
        window.addEventListener('unload', function (event) {
            // Send close event only if the page is not being refreshed
            if (!isRefreshed) {
                sendMessageToFlutter('close');
            }
        });

        // Add event listener for load event (page load)
        window.addEventListener('load', function (event) {
            // Reset flag when the page loads again
            isRefreshed = false;
        });
    </script>
</head>

<body>
    <!-- Entry point for Flutter app -->
    <div id="flutter-app-container"></div>
    <script src="main.dart.js" type="application/javascript"></script>
</body>

</html>