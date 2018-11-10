-- $Id: memory_stream.adb,v 1.1 2000/11/26 05:00:18 wwg Exp $
-- (c) Warren W. Gay VE3WWG ve3wwg@home.com, ve3wwg@yahoo.com
--
-- Protected under the GNU GPL License

with Ada.Text_IO; use Ada.Text_IO;

with Ada.Finalization; use Ada.Finalization;
with Ada.IO_Exceptions; use Ada.IO_Exceptions;
with Ada.Unchecked_Deallocation;

package body Memory_Stream is

    --------------------------------------------------
    -- Read from a Memory Buffer Stream :
    --------------------------------------------------
    procedure Read(Stream: in out Memory_Buffer_Stream; Item: out Stream_Element_Array; Last: out Stream_Element_Offset) is
    begin
        Read(Stream.Mem_Buf,Item,Last);
    end Read;

    --------------------------------------------------
    -- Write to a Memory Buffer Stream :
    --------------------------------------------------
    procedure Write(Stream: in out Memory_Buffer_Stream; Item: in Stream_Element_Array) is
    begin
        Write(Stream.Mem_Buf,Item);
    end Write;

    --------------------------------------------------
    -- Rewind the Read Memory Buffer Index
    --------------------------------------------------
    procedure Rewind_Read(Stream: Stream_Access) is
        Mem_Str:    Memory_Buffer_Stream_Ptr := Memory_Buffer_Stream_Ptr(Stream);
    begin
        Rewind_Read(Mem_Str.Mem_Buf);
    end Rewind_Read;

    --------------------------------------------------
    -- Rewind the Write Memory Buffer Index
    --------------------------------------------------
    procedure Rewind_Write(Stream: Stream_Access) is
        Mem_Str:    Memory_Buffer_Stream_Ptr := Memory_Buffer_Stream_Ptr(Stream);
    begin
        Rewind_Write(Mem_Str.Mem_Buf);
    end Rewind_Write;

    --------------------------------------------------
    -- Free a Memory Buffer Stream :
    --------------------------------------------------
    procedure Free(Stream: Stream_Access) is
        type Memory_Buffer_Stream_Ptr is access all Memory_Buffer_Stream;
        procedure Free_Stream is new Ada.Unchecked_Deallocation(Memory_Buffer_Stream,Memory_Buffer_Stream_Ptr);
        Str_Ptr:    Memory_Buffer_Stream_Ptr := Memory_Buffer_Stream_Ptr(Stream);
    begin
        Free_Stream(Str_Ptr);
    end Free;

    --------------------------------------------------
    -- Private Implementation :
    --------------------------------------------------

    --------------------------------------------------
    -- Initialize a Memory_Buffer Object :
    --------------------------------------------------
    procedure Initialize(Buf: in out Memory_Buffer) is
    begin
        Buf.Read_Offset := Buf.Buffer'First;
        Buf.Write_Offset := Buf.Buffer'First;
    end Initialize;

    --------------------------------------------------
    -- Write to a Memory Buffer Object :
    --------------------------------------------------
    procedure Write(Buf: in out Memory_Buffer; Item: Stream_Element_Array) is
        Count:      Stream_Element_Offset := Item'Last + 1 - Item'First;
        Last:       Stream_Element_Offset := Buf.Write_Offset + Count - 1;
    begin

        if Last > Buf.Buffer'Last then
            raise Ada.IO_Exceptions.End_Error;
        end if;

        Buf.Buffer(Buf.Write_Offset..Last) := Item;
        Buf.Write_Offset := Buf.Write_Offset + Count;
    end Write;

    --------------------------------------------------
    -- Read from a Memory Buffer Object :
    --------------------------------------------------
    procedure Read(Buf: in out Memory_Buffer; Item: out Stream_Element_Array; Last: out Stream_Element_Offset) is
        Xfer_Count: Stream_Element_Offset := Item'Last + 1 - Item'First;
        Data_Count: Stream_Element_Offset := Buf.Write_Offset - Buf.Read_Offset;
    begin

        if Xfer_Count > Data_Count then
            Xfer_Count := Data_Count;
        end if;

        Item(1..Xfer_Count) := Buf.Buffer(Buf.Read_Offset..Buf.Read_Offset+Xfer_Count-1);
        Buf.Read_Offset := Buf.Read_Offset + Xfer_Count;
        Last := Item'First + Xfer_Count - 1;
    end Read;

    --------------------------------------------------
    -- Rewind the Read offset in the Memory Buffer
    --------------------------------------------------
    procedure Rewind_Read(Buf: in out Memory_Buffer) is
    begin
        Buf.Read_Offset := Buf.Buffer'First;
    end Rewind_Read;

    --------------------------------------------------
    -- Rewind the Write offset in the Memory Buffer
    --------------------------------------------------
    procedure Rewind_Write(Buf: in out Memory_Buffer) is
    begin
        Buf.Read_Offset := Buf.Buffer'First;    -- Implies a Read offset rewind
        Buf.Write_Offset := Buf.Buffer'First;   -- Rewind the write offset
    end Rewind_Write;
end Memory_Stream;
