# Percolate

Features

Coffee Percolate displays the coffee list in a table 

On selecting a particular coffee type, a detail view of the coffee is shown

The contents are available offline when the Network connectivity is not available



Implemented using

IOS 8.4 & XCode 6.4

Using AFNetworking for Network Calls

Used Mantle for Object Serialization

Used Auto Layout for laying out the UI


Assumptions

The coffee list offline contents are accessed only when the network connectivity is not available

If any contents is not available in the cache, an alert message that says "no network connection available" is displayed & the detail view is pushed back to the coffee list

