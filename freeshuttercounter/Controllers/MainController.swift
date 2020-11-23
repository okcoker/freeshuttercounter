//
//  MainController.swift
//  freeshuttercounter
//
//  Created by Sean Coker on 11/20/20.
//  Copyright © 2020 Oleg Orlov. All rights reserved.
//

import Foundation
import AppKit

func camera_get_config(_ camera: Camera?, _ context: GPcontext?, _ key: UnsafePointer<Int8>?) -> String? {
    var widget: CameraWidget? = nil
    var child: CameraWidget? = nil
    var type: CameraWidgetType
    var value: UnsafeMutablePointer<Int8>?

    if gp_camera_get_config(camera, &widget, context) < GP_OK {
        return "gp_camera_get_config failed.\n"
    }

    if (gp_widget_get_child_by_name(widget, key, &child) < GP_OK) && (gp_widget_get_child_by_label(widget, key, &child) < GP_OK) {
        gp_widget_free(widget)
        return "gp_widget_get_child failed.\n"
    }

    if gp_widget_get_type(child, &type) < GP_OK {
        gp_widget_free(widget)
        return "gp_widget_get_type failed.\n"
    }
    
    switch type {
        case GP_WIDGET_MENU, GP_WIDGET_TEXT, GP_WIDGET_RADIO:
            break
        default:
            gp_widget_free(widget)
            return "widget has bad type.\n"
    }

    if gp_widget_get_value(child, &value) < GP_OK {
        gp_widget_free(widget)
        return "gp_widget_get_value failed.\n"
    }

    let out = String(utf8String: value)
    gp_widget_free(widget)
    return out
}

// Kill the process PTPCamera
func kill_PTPCamera() {
    if NSRunningApplication.responds(to: #selector(NSRunningApplication.runningApplications(withBundleIdentifier:))) {
        for app in NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.PTPCamera") {
            app.forceTerminate()
        }
    }
}

func camera_get_info() -> String? {
    var camera: Camera?
    var context: GPContext?

    var output = ""

    kill_PTPCamera()

    context = gp_context_new()
    gp_camera_new(&camera)

    if gp_camera_init(camera, context) < GP_OK {
        output += "No camera detected.\nTry again."
        gp_camera_free(camera)
        return output
    }

    output += "\(camera_get_config(camera, context, "cameramodel")) \n"
    //[output appendFormat:@"Version: %@\n", camera_get_config(camera, context, "deviceversion")];
    output += "Shutter count: \(camera_get_config(camera, context, "shuttercounter"))"

    gp_camera_exit(camera, context)
    gp_camera_free(camera)
    gp_context_unref(context)

    return output
}
