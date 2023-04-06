package com.example.projet_fin_annee_2gt

import android.Manifest
import io.flutter.embedding.android.FlutterFragmentActivity

//Imports To call Android NAtive code in flutter
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

//Imports to get network infos
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.telephony.*
import android.telephony.gsm.GsmCellLocation
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat

import android.telephony.CellInfo
import android.telephony.CellInfoGsm
import android.telephony.CellInfoWcdma
import android.telephony.CellInfoLte
import android.telephony.CellSignalStrengthGsm
import android.telephony.CellSignalStrengthWcdma
import android.telephony.CellSignalStrengthLte
import android.telephony.TelephonyManager
import android.telephony.PhysicalChannelConfig
import android.telephony.ServiceState
import android.telephony.SubscriptionManager


class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "com.example.projet_fin_annee_2gt/cell_info"

    @RequiresApi(Build.VERSION_CODES.R)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            // This method is invoked on the main thread.
            // TODO
            if (call.method == "getCellInfo"){
                val arguments = call.arguments<Map<String,String>>()
                val  name = arguments?.get("RX")
                
                val cellInfo = getInfo()
                result.success(cellInfo)
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.R)
    private fun getInfo(): HashMap<String,String>{
        // Creating the HashMap
        val info: HashMap<String,String> = HashMap()
        val tm = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.

        }
        else {
            //if permissions granted
            val cellInfo = tm.allCellInfo?.get(0)
            println(cellInfo)
            if (cellInfo is CellInfoGsm) { if (cellInfo != null ) {
                val cellIdentity = cellInfo.cellIdentity
                val cellSignalStrength = cellInfo.cellSignalStrength
                val mcc = cellIdentity.mccString
                val mnc = cellIdentity.mncString
                val lac = cellIdentity.lac.toString()
                val cellId = cellIdentity.cid.toString()
                val signalStrength = cellSignalStrength.dbm.toString()
                val arfcn = cellIdentity.arfcn
                val band = when (arfcn) {
                    in 0..124 -> "GSM 900"
                    in 128..251 -> "DCS 1800"
                    in 259..293 -> "PCS 1900"
                    else -> "Unknown"
                }


                // Adding a key-value pair
                info.apply {
                    put("phoneType", "GSM")
                    //put("cellIdentity", cellIdentity.toString())
                    //put("cellSignalStrength", cellSignalStrength.toString())
                    put("mcc", mcc.toString())
                    put("mnc", mnc.toString())
                    put("lac", lac)
                    put("cellId", cellId)
                    put("signalStrength", signalStrength)
                    put("Band", band)
                }// use the above values as needed
            }}
            if (cellInfo is CellInfoWcdma) {
                val strphoneType = "WCDMA"
                val cellIdentity = cellInfo.cellIdentity
                val cellSignalStrength = cellInfo.cellSignalStrength
                val mcc = cellIdentity.mccString
                val mnc = cellIdentity.mncString
                val uarfcn = cellIdentity.uarfcn
                val ecio = cellSignalStrength.dbm
                val psc = cellIdentity.psc
                val cellId = cellIdentity.cid
                val lac = cellIdentity.lac
                // Get RSSI (Received Signal Strength Indicator) in dBm
                val rssi = cellSignalStrength.dbm
                // Get RSCP (Received Signal Code Power) in dBm
                val rscp = cellSignalStrength.asuLevel
                // Get EC/NO (Ratio of Received Energy to Interference) in dB
                val ecno = cellSignalStrength.dbm - cellInfo.cellSignalStrength.asuLevel
                //Band
                val band = when (uarfcn) {
                    in 10562..10838 -> "2100"
                    in 2937..3088 -> "900"
                    else -> "Unknown"
                }


                info.apply {
                    put("phoneType", strphoneType)
                    //put("cellIdentity", cellIdentity.toString())
                    //put("cellSignalStrength", cellSignalStrength.toString())
                    put("mcc", mcc.toString())
                    put("mnc", mnc.toString())
                    put("uarfcn", uarfcn.toString())
                    put("ecio", ecio.toString())
                    put("rssi", rssi.toString())
                    put("rscp", rscp.toString())
                    put("ecno", ecno.toString())
                    put("psc", psc.toString())
                    put("lac",  lac .toString())
                    put("cellId", cellId.toString())
                    put("band", band)
                }

            }
            if (cellInfo is CellInfoLte) {
                val strphoneType = "LTE"
                val cellIdentity = cellInfo.cellIdentity
                val cellSignalStrength = cellInfo.cellSignalStrength
                val mcc = cellIdentity.mccString
                val mnc = cellIdentity.mncString
                val cellId = cellIdentity.ci
                val pci = cellIdentity.pci
                val earfcn = cellIdentity.earfcn
                val rsrp = cellSignalStrength.rsrp
                val rsrq = cellSignalStrength.rsrq
                val rssi = cellSignalStrength.rssi
                val cqi = cellSignalStrength.cqi
                val ta = cellSignalStrength.timingAdvance
                //Band
                val band = when (earfcn) {
                    in 1200..1949 -> "3"
                    in 2750..3449 -> "7"
                    in 6150..6449 -> "20"
                    else -> "Unknown"
                }
                val bandWidth = cellIdentity.bandwidth /1000
                var sinr: Int? = null
                if (rssi!= CellInfo.UNAVAILABLE && rsrp!=CellInfo.UNAVAILABLE) { sinr = rssi - rsrp }
                val tac = cellIdentity.tac

                info.apply {
                    put("phoneType", strphoneType)
                    //put("cellIdentity", cellIdentity.toString())
                    //put("cellSignalStrength", cellSignalStrength.toString())
                    put("mcc", mcc.toString())
                    put("mnc", mnc.toString())
                    put("pci", pci.toString())
                    put("cellId", cellId.toString())
                    put("earfcn", earfcn.toString())
                    put("rssi", rssi.toString())
                    put("rsrp", rsrp.toString())
                    put("rsrq", rsrq.toString())
                    put("cqi", cqi.toString())
                    put("ta",  ta.toString())
                    put("band", band)
                    put("bandWidth", bandWidth.toString())
                    put("sinr", sinr.toString())
                    put("tac", tac.toString())
                }


            }



        }


        return info
    }

}
