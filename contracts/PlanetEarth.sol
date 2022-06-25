// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PlanetEarth {

    uint256 population;
    string continent;

    string[7] private Continents = ["Asia", "Africa", "Antartica", "Australia", "Europe", "North America", "South America"];

    struct Country {
        string country;
        string capital;
        string continent;
        uint population;
        uint index;
    }

    string[] private countryIndex;
    string[] private capitalIndex;


    mapping (string => Country) private Countries;
    mapping (string => Country) private Capitals;
    mapping (string => string) private euroCapitals;
    mapping (string => bool) euroCap;


    event LogNewCountry   (string country, string capital, uint population, string continent, uint index);
    event LogUpdateCountry(string country, string capital, uint population, string continent, uint index);
    event LogDeleteCountry(string country, uint index);

    constructor() public {

        euroCap["Tirana"] = true;
        euroCap["Andorra la Vella"] = true;
        euroCap["Vienna"] = true;
        euroCap["Minsk"] = true;
        euroCap["Brussels"] = true;
        euroCap["Sarajevo"] = true;
        euroCap["Sofia"] = true;
        euroCap["Zagreb"] = true;
        euroCap["Nicosia"] = true;
        euroCap["Prague"] = true;
        euroCap["Copenhagen"] = true;
        euroCap["Tallinn"] = true;
        euroCap["Helsinki"] = true;
        euroCap["Paris"] = true;
        euroCap["Berlin"] = true;
        euroCap["Gibraltar"] = true;
        euroCap["Athens"] = true;
        euroCap["St. Peter Port"] = true;
        euroCap["Budapest"] = true;
        euroCap["Reykjavik"] = true;
        euroCap["Dublin"] = true;
        euroCap["Douglas"] = true;
        euroCap["Rome"] = true;
        euroCap["Saint Helier"] = true;
        euroCap["Pristina"] = true;
        euroCap["Riga"] = true;
        euroCap["Vaduz"] = true;
        euroCap["Vilnius"] = true;
        euroCap["Luxembourg"] = true;
        euroCap["Skopje"] = true;
        euroCap["Valletta"] = true;
        euroCap["Monaco"] = true;
        euroCap["Podgorica"] = true;
        euroCap["Amsterdam"] = true;
        euroCap["Oslo"] = true;
        euroCap["Warsaw"] = true;
        euroCap["Lisban"] = true;
        euroCap["Bucharest"] = true;
        euroCap["Moscow"] = true;
        euroCap["City of San Marino"] = true;
        euroCap["Belgrade"] = true;
        euroCap["Bratislava"] = true;
        euroCap["Ljubljana"] = true;
        euroCap["Madrid"] = true;
        euroCap["Longyearbyen"] = true;
        euroCap["Stockholm"] = true;
        euroCap["Bern"] = true;
        euroCap["Keiv"] = true;
        euroCap["London"] = true;
        euroCap["Vatican City"] = true;

       // euroCapitals[country] = capital;
        euroCapitals["Albania"] = "Tirana";
        euroCapitals["Andorra"] = "Andorra la Vella";
        euroCapitals["Armenia"] = "Yerevan";
        euroCapitals["Austria"] = "Vienna";
        euroCapitals["Azerbaijan"] = "Baku";
        euroCapitals["Belarus"] = "Minsk";
        euroCapitals["Belgium"] = "Brussels";
        euroCapitals["Bosnia"] = "Sarajevo";
        euroCapitals["Croatia"] = "Zagreb";
        euroCapitals["Cyprus"] = "Nicosia";
        euroCapitals["Czechia"] = "Prague";
        euroCapitals["Denmark"] = "Copenhagen";
        euroCapitals["Estonia"] = "Tallinn";
        euroCapitals["Finland"] = "Helsinki";
        euroCapitals["France"] = "Paris";
        euroCapitals["Georgia"] = "Tbilisi";
        euroCapitals["Germany"] = "Berlin";
        euroCapitals["Greece"] = "Athens";
        euroCapitals["Hungary"] = "Budapest";
        euroCapitals["Iceland"] = "Reyjavik";
        euroCapitals["Ireland"] = "Dublin";
        euroCapitals["Italy"] = "Rome";
        euroCapitals["Kazzakhstan"] = "Nur-Sultan";
        euroCapitals["Kosovo"] = "Pristina";
        euroCapitals["Latvia"] = "Riga";
        euroCapitals["Liechtenstein"] = "Vaduz";
        euroCapitals["Lithuania"] = "Vilnius";
        euroCapitals["Luxembourg"] = "Luxembourg";
        euroCapitals["Malta"] = "Valletta";
        euroCapitals["Modova"] = "Chisinau";
        euroCapitals["Monaco"] = "Monaco";
        euroCapitals["Montenegro"] = "Podgorica";
        euroCapitals["Netherlands"] = "Amsterdam";
        euroCapitals["North Macedonia"] = "Skopje";
        euroCapitals["Norway"] = "Oslo";
        euroCapitals["Poland"] = "Warsaw";
        euroCapitals["Portugal"] = "Lisbon";
        euroCapitals["Romania"] = "Bucharest";
        euroCapitals["Russia"] = "Moscow";
        euroCapitals["San Marino"] = "San Marino";
        euroCapitals["Serbia"] = "Belgrade";
        euroCapitals["Slovakia"] = "Bratislava";
        euroCapitals["Slovenia"] = "Ljubljana";
        euroCapitals["Spain"] = "Madrid";
        euroCapitals["Sweden"] = "Stockholm";
        euroCapitals["Switzerland"] = "Bern";
        euroCapitals["Turkey"] = "Ankara";
        euroCapitals["Ukraine"] = "Kyiv";
        euroCapitals["United Kingdom"] = "London";
        euroCapitals["Vatican City"] = "Vatican City";

    }

    function hashCompareWithLengthCheck(string memory a, string memory b) internal pure returns (bool) {
        if(bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return keccak256(bytes(a)) == keccak256(bytes(b));
        }
    }

    function isCountry(string memory country) //USE for address TRUE mapping for allowing authorization
    public
    view
    returns(bool isIndeed)
    {
        if(countryIndex.length == 0) return false;

        return keccak256(bytes(country)) == keccak256(bytes(countryIndex[Countries[country].index]));
    }

    function isCapital(string memory capital) //USE for address TRUE mapping for allowing authorization
    internal
    returns(bool isIndeed)
    {
        if(capitalIndex.length == 0) return false;

        return keccak256(bytes(capital)) == keccak256(bytes(capitalIndex[Capitals[capital].index]));
    }

    function addCountry(
        string memory country,
        string memory capital,
        string memory continent,
        uint population)
    public
    returns(uint index)
    {
        require(!isCountry(country), "Will not allow duplicates");
        require(bytes(euroCapitals[country]).length != 0, "Country provided is not European");
        require(hashCompareWithLengthCheck(capital,euroCapitals[country]) == true, "Capital provided does not match Country");
        require(hashCompareWithLengthCheck(continent,"Europe"), "Continent provided is not Europe");
        
        Capitals[capital].index        = capitalIndex.push(capital)-1;
        Countries[country].capital     = capital;
        Countries[country].continent   = continent;
        Countries[country].index       = countryIndex.push(country)-1;
        Countries[country].population  = population;
        emit LogNewCountry (country, capital, population, continent, Countries[country].index);
        return countryIndex.length-1;
    }

    function getCountryInfo(string memory country)
    public
    view
    returns(string memory capital, uint population, uint index)
    {
      require(isCountry(country), "Country requested is not within array");

        return(
        Countries[country].capital,
        Countries[country].population,
        Countries[country].index);
    }

    function updateCapital(string memory country, string memory capital)
    public
    returns(bool success)
    {

        require(isCountry(country), "Country requested is not within array");


        if (hashCompareWithLengthCheck(capital,euroCapitals[country]) == true){

            Countries[country].capital = capital;

            emit LogUpdateCountry(country, capital, population, continent, Countries[country].index);
            return true;

        } else {

            require(!isCapital(capital), "Capital requested is already in allocated");
            require(!euroCap[capital], "Will not allow duplicate Capitals");

            Countries[country].capital = capital;

            emit LogUpdateCountry(country, capital, population, continent, Countries[country].index);
            return true;
        }

    }

    function deleteCountry(string memory country)
    public
    returns(uint index)
    {
      require(isCountry(country), "Country requested is not within array");

        uint rowToDelete = Countries[country].index;
        string memory keyToMove = countryIndex[countryIndex.length-1];
        countryIndex[rowToDelete] = keyToMove;
        Countries[keyToMove].index = rowToDelete;
        countryIndex.length--;
        emit LogDeleteCountry(
            country,
            rowToDelete);
        emit LogUpdateCountry(
            keyToMove,
            Countries[keyToMove].capital,
            Countries[keyToMove].population,
            Countries[keyToMove].continent,
            rowToDelete);
        return rowToDelete;
    }

    function getCountryCount()
    public
    view
    returns(uint count)
    {
        return countryIndex.length;
    }

    function getCountryAtIndex(uint index)
    public
    view
    returns(string memory country)
    {
        require(index < countryIndex.length, "Country index must be within range");
        return countryIndex[index];
    }

    function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory ab = new string(_ba.length + _bb.length);
        bytes memory bab = bytes(ab);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
        for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
        return string(bab);
    }

/*
    function getCountries() public view returns(string[] memory) {
        return countryIndex;
    }
*/

    function getContinents(uint256 index) public view returns(string memory) {

        require(index < Continents.length, "Continent index must be within range");

        return Continents[index];
    }

    function getCountryList() public view returns(string memory) {
        require(gasleft()>20,
        "Not enough gas left.");
        string memory rString;

        for(uint i = 0; i < countryIndex.length; i++) {
            rString = strConcat(rString,countryIndex[i]);
            rString = strConcat(rString,",");
        }
        return rString;
    }

/*
    function getAllEuroCountries() public view returns(string[] memory) {
        return euroCountries;
    }
*/

    function getGasLeft() public view returns(uint) {
        return gasleft();
    }


}