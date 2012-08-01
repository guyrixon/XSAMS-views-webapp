function convertAllVacuumToAir() {
  var spans=document.getElementsByTagName("span");
  for (i = 0; i < spans.length; i++) {
    var unit = spans[i].getAttribute("wavelength")
    if (unit != undefined) {
      spans[i].textContent=vacuumToAir(spans[i].textContent, unit)
    }
  }
}

function convertAllAirToVacuum() {
  var spans=document.getElementsByTagName("span");
  for (i = 0; i < spans.length; i++) {
    var unit = spans[i].getAttribute("wavelength")
    if (unit != undefined) {
      spans[i].textContent=airToVacuum(spans[i].textContent, unit)
    }
  }
}

// Convert wavelength in vacuum to wavelength in air, IAU STP, both values in Angstrom
function vacuumToAir(lVac, unit) {
  var s = 1.0e4 / toAngstroms(lVac, unit)
  var s2 = s * s
  var n = 1 + 0.0000834254 + (0.02406147 / (130.0 - s2)) + (0.00015998 / (38.9 - s2))
  return lVac / n
}

// Convert wavelength in air, IAU STP, to wavelength in vacuum, both values in Angstrom
function airToVacuum(lAir, unit) {
  var s = 1.0e4 / toAngstroms(lAir, unit)
  var s2 = s * s
  var n = 1 + 0.00008336624212083 + (0.02408926869968 / (130.1065924522 - s2)) + (0.0001599740894897 / (38.92568793293 - s2))
  return lAir * n
}

// Convert wavelength in arbitrary unit (allowed by XSAMS) to Angstrom
function toAngstroms(l, unit) {
  if (unit == "A" || unit == undefined) {
    return  l
  }
  if (unit == "m") {
    return l * 1.0e10
  }
  if (unit == "cm") {
    return l * 1.0e8
  }
  if (unit == "nm") {
    return l * 10
  }
}