# Capacitive Self Attendance System

**Autores:** Adevaldo dos Santos Pinto Junior, Enzo Nogueira Barrese, Mariana Mendes Lima, Nicolas Sobral Cruz e Paulo Felipe Espinar Sanchez  

**Curso:** Engenharia Mecatrônica  
**Disciplina:** Instrumentação (PMR-3408) 
**Instituição:** Escola Politécnica da USP  

---

## Descrição do Projeto

O **Capacitive Self Attendance System** é um sistema baseado em Arduino que utiliza **sensores capacitivos** para detectar a aproximação de um usuário a uma placa de alumínio, sem necessidade de contato físico.  

O projeto tem como objetivo permitir a **inicialização da interação do usuário e registro automático**, funcionando como uma interface de seleção para sistemas digitais. A interação é processada pelo **Arduino** e exibida em uma interface gráfica desenvolvida no **Processing**, garantindo feedback visual ao usuário.  

Este projeto foi desenvolvido como parte do **Trabalho de Instrumentação** do curso de Engenharia Mecatrônica da Escola Politécnica da USP.  

---

## Funcionalidades

- Detecção da proximidade da mão do usuário em relação à placa de alumínio.  
- Registro da medida de capacitância e envio para o computador via **Serial**.  
- Visualização em tempo real na interface gráfica desenvolvida em **Processing**.  
- Fluxo de interação simples: inicialização → seleção de itens → resumo do pedido.  

---

## Estrutura do Projeto

- `CSAS_hardware/` → Código Arduino responsável pela leitura do sensor capacitivo.  
- `CSAS_interface/` → Sketch do Processing para interface gráfica e visualização das medições.  
- `README.md` → Documentação do projeto.  

---

## Materiais Necessários

- Arduino Uno (ou compatível)  
- Fio blindado trançado 
- 1 resistor de 10 kΩ  
- 1 resistor de 220 kΩ  
- Placa de alumínio para o sensor capacitivo  

**Passo a passo de montagem utilizado como referência:**  
[A Touchless 3D Tracking Interface](https://makezine.com/projects/a-touchless-3d-tracking-interface/)  

---

## Como Utilizar

1. Conectar a placa de alumínio ao Arduino conforme o esquema do tutorial.  
2. Abrir o código Arduino no **Arduino IDE** e carregar no Arduino.  
3. Abrir o sketch no **Processing** para visualizar a interface gráfica.  
4. Aproximar a mão da placa de alumínio e observar os valores de capacitância sendo exibidos na tela.  

---

## Observações

- O sistema mede capacitância entre a placa e a mão.  
- Resistores são utilizados para proteger o Arduino contra possíveis descargas eletrostáticas.  
- Este projeto tem caráter **acadêmico** e foi desenvolvido exclusivamente para fins educacionais.  

---

## Licença

Este projeto está licenciado sob a MIT License.  
Veja o arquivo [LICENSE](LICENSE) para mais detalhes.