<?php
$jsonString = file_get_contents('/data/options.json');

// Decode the JSON data into a PHP array
$configData = json_decode($jsonString, true);

// Check if the JSON decoding was successful
if ($configData === null) {
    die('Error decoding JSON');
}

// Define the constants using the values from the JSON array
define('CUSTOMERNR', $configData['netcupCustomerNumber']);
define('APIPASSWORD', $configData['netcupApiPassword']);
define('APIKEY', $configData['netcupApiKey']);
define('DOMAINLIST', $configData['domainList']);
define('USE_IPV4', true);
define('USE_IPV6', false);
define('CHANGE_TTL', true);
define('APIURL', 'https://ccp.netcup.net/run/webservice/servers/endpoint.php?JSON');
