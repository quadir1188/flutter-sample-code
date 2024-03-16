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