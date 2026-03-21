#pragma once

#include <adwaita.h>

// g_signal_connect is a macro that Swift cannot import.
// Provide inline wrappers around g_signal_connect_data.

static inline gulong
cadw_signal_connect(gpointer instance, const gchar *detailed_signal,
                    GCallback c_handler, gpointer data)
{
    return g_signal_connect_data(instance, detailed_signal, c_handler, data,
                                NULL, (GConnectFlags)0);
}

static inline gulong
cadw_signal_connect_after(gpointer instance, const gchar *detailed_signal,
                          GCallback c_handler, gpointer data)
{
    return g_signal_connect_data(instance, detailed_signal, c_handler, data,
                                NULL, G_CONNECT_AFTER);
}

static inline gulong
cadw_signal_connect_swapped(gpointer instance, const gchar *detailed_signal,
                            GCallback c_handler, gpointer data)
{
    return g_signal_connect_data(instance, detailed_signal, c_handler, data,
                                NULL, G_CONNECT_SWAPPED);
}

// GObject casting macros are not importable in Swift.
// Provide typed cast helpers.

static inline GObject *
cadw_cast_gobject(gpointer obj)
{
    return G_OBJECT(obj);
}

static inline GtkWidget *
cadw_cast_widget(gpointer obj)
{
    return GTK_WIDGET(obj);
}

static inline GtkWindow *
cadw_cast_window(gpointer obj)
{
    return GTK_WINDOW(obj);
}

static inline GtkApplication *
cadw_cast_application(gpointer obj)
{
    return GTK_APPLICATION(obj);
}

static inline AdwApplication *
cadw_cast_adw_application(gpointer obj)
{
    return ADW_APPLICATION(obj);
}

static inline AdwApplicationWindow *
cadw_cast_adw_application_window(gpointer obj)
{
    return ADW_APPLICATION_WINDOW(obj);
}

// GType fundamental type macros are not importable in Swift.

static inline GType cadw_type_boolean(void) { return G_TYPE_BOOLEAN; }
static inline GType cadw_type_int(void)     { return G_TYPE_INT; }
static inline GType cadw_type_uint(void)    { return G_TYPE_UINT; }
static inline GType cadw_type_int64(void)   { return G_TYPE_INT64; }
static inline GType cadw_type_uint64(void)  { return G_TYPE_UINT64; }
static inline GType cadw_type_float(void)   { return G_TYPE_FLOAT; }
static inline GType cadw_type_double(void)  { return G_TYPE_DOUBLE; }
static inline GType cadw_type_string(void)  { return G_TYPE_STRING; }
static inline GType cadw_type_object(void)  { return G_TYPE_OBJECT; }

// G_VALUE_HOLDS_* macros

static inline gboolean cadw_value_holds_string(const GValue *value) {
    return G_VALUE_HOLDS_STRING(value);
}

static inline gboolean cadw_value_holds_int(const GValue *value) {
    return G_VALUE_HOLDS_INT(value);
}

static inline gboolean cadw_value_holds_boolean(const GValue *value) {
    return G_VALUE_HOLDS_BOOLEAN(value);
}

static inline gboolean cadw_value_holds_double(const GValue *value) {
    return G_VALUE_HOLDS_DOUBLE(value);
}
