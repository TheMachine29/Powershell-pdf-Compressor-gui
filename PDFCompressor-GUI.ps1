Add-Type -AssemblyName System.Windows.Forms

function Show-PDFCompressionGUI {
    
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Compresor de PDF (Ghostscript)"
    $form.Size = New-Object System.Drawing.Size(480, 280)
    $form.StartPosition = "CenterScreen"

    
    $labelPDF = New-Object System.Windows.Forms.Label
    $labelPDF.Text = "PDF Original:"
    $labelPDF.Location = New-Object System.Drawing.Point(10, 20)
    $labelPDF.Size = New-Object System.Drawing.Size(100, 20)
    $form.Controls.Add($labelPDF)

    $txtPDF = New-Object System.Windows.Forms.TextBox
    $txtPDF.Location = New-Object System.Drawing.Point(110, 20)
    $txtPDF.Size = New-Object System.Drawing.Size(250, 20)
    $form.Controls.Add($txtPDF)

    $btnBrowse = New-Object System.Windows.Forms.Button
    $btnBrowse.Text = "Buscar"
    $btnBrowse.Location = New-Object System.Drawing.Point(370, 18)
    $btnBrowse.Add_Click({
        $ofd = New-Object System.Windows.Forms.OpenFileDialog
        $ofd.Filter = "PDF Files (*.pdf)|*.pdf"
        if ($ofd.ShowDialog() -eq "OK") {
            $txtPDF.Text = $ofd.FileName
        }
    })
    $form.Controls.Add($btnBrowse)

    
    $labelNivel = New-Object System.Windows.Forms.Label
    $labelNivel.Text = "Nivel de compresión:"
    $labelNivel.Location = New-Object System.Drawing.Point(10, 60)
    $form.Controls.Add($labelNivel)

    $combo = New-Object System.Windows.Forms.ComboBox
    $combo.Location = New-Object System.Drawing.Point(150, 60)
    $combo.Size = New-Object System.Drawing.Size(200, 20)
    $combo.Items.AddRange(@("/screen","/ebook","/printer","/prepress"))
    $combo.SelectedIndex = 0
    $form.Controls.Add($combo)

    
    $btnComprimir = New-Object System.Windows.Forms.Button
    $btnComprimir.Text = "Comprimir PDF"
    $btnComprimir.Location = New-Object System.Drawing.Point(150, 110)
    $btnComprimir.Size = New-Object System.Drawing.Size(150,30)

    $btnComprimir.Add_Click({
        $inputPDF = $txtPDF.Text

        
        if (-not (Test-Path $inputPDF)) {
            [System.Windows.Forms.MessageBox]::Show("Archivo no encontrado.","Error")
            return
        }

        if ([System.IO.Path]::GetExtension($inputPDF).ToLower() -ne ".pdf") {
            [System.Windows.Forms.MessageBox]::Show("El archivo seleccionado no es un PDF.","Error")
            return
        }

        $sfd = New-Object System.Windows.Forms.SaveFileDialog
        $sfd.Filter = "PDF File (*.pdf)|*.pdf"
        $sfd.Title = "Guardar PDF Comprimido"
        $sfd.FileName = "PDF_comprimido.pdf"
        if ($sfd.ShowDialog() -ne "OK") { return }

        $outputPDF = $sfd.FileName
        $nivel = $combo.SelectedItem

        $gsPath = "C:\Program Files\gs\gs10.05.1\bin\gswin64c.exe"
        if (-not (Test-Path $gsPath)) {
            [System.Windows.Forms.MessageBox]::Show("No se encontró Ghostscript en la ruta esperada.`nVerifique que esté instalado.","Error")
            return
        }

        
        $argumentos = @(
            "-sDEVICE=pdfwrite",
            "-dCompatibilityLevel=1.4",
            "-dPDFSETTINGS=$nivel",
            "-dNOPAUSE",
            "-dQUIET",
            "-dBATCH",
            "-sOutputFile=`"$outputPDF`"",
            "`"$inputPDF`""
        )

        Start-Process -FilePath $gsPath -ArgumentList $argumentos -Wait

        [System.Windows.Forms.MessageBox]::Show("PDF comprimido exitosamente.","Éxito")
    })
    $form.Controls.Add($btnComprimir)

   
    $form.Topmost = $true
    $form.Add_Shown({ $form.Activate() })
    [void]$form.ShowDialog()
}

Show-PDFCompressionGUI
