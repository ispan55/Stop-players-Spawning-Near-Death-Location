/**
 * ExileClient_gui_selectSpawnLocation_show
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */

private["_display","_spawnButton","_listBox","_listItemIndex","_numberOfSpawnPoints","_randNum","_randData","_randomSpawnIndex"];
disableSerialization;
ExileClientSpawnLocationSelectionDone = false;
ExileClientSelectedSpawnLocationMarkerName = "";
createDialog "RscExileSelectSpawnLocationDialog";
waitUntil
{
	_display = findDisplay 24002;
	!isNull _display
};
_spawnButton = _display displayCtrl 24003;
_spawnButton ctrlEnable false;
_display displayAddEventHandler ["KeyDown", "_this call ExileClient_gui_loadingScreen_event_onKeyDown"];
_listBox = _display displayCtrl 24002;
lbClear _listBox;
_blackList = [];
{
	if (getMarkerType _x == "ExileSpawnZone") then
	{
		_markerName = markerText _x;
		_markerData = _x;
        _playerDeathPos = getMarkerPos ExileClientLastDeathMarker;
        _spawnPos = getMarkerPos _x;
        _minDistance = 3000; //Change this to suit your need
		_coolDownTime = 900; //Whats the cooldown time in seconds you pleb
		{
		    _deathPos = _x select 0;
			_deathTime = _x select 1;
			if ((_deathPos distance _spawnPos < _minDistance) && (diag_tickTime - _deathTime < _coolDownTime)) then {
				_blackList pushBack _markerName;
			};
		} forEach DeathArray;
		if !(_markerName in _blackList) then {
			_listItemIndex = _listBox lbAdd Format["%1",_markerName];
			_listBox lbSetData [_listItemIndex, _markerData];
		};
	};
}
forEach allMapMarkers;
_numberOfSpawnPoints = {getMarkerType _x == "ExileSpawnZone"} count allMapMarkers;
if (_numberOfSpawnPoints > 0) then
{
	_randNum = floor(random _numberOfSpawnPoints);
	_randData = lbData [24002,_randNum];
	_randomSpawnIndex = _listBox lbAdd "Random";
	_listBox lbSetData [_randomSpawnIndex, _randData];
};
true
