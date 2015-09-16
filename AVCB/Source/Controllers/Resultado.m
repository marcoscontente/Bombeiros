//
//  Resultado.m
//  AVCB
//
//  Created by Vinicius on 9/2/15.
//  Copyright (c) 2015 Prodesp. All rights reserved.
//

#import "Resultado.h"

@implementation Resultado

- (void)viewDidLoad
{
    [super viewDidLoad];
    autoData = [[Util shared] respostaChamada];
    distance = [[Util shared] distance];
    localizacaoHabilitado = [[Util shared] localizacaoHabilitado];
    tabela.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.title = @"Consulta Licenças";
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (localizacaoHabilitado)
    {
        return 7;
    }
    return 6;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UITableViewCell *raioCell = [tableView dequeueReusableCellWithIdentifier:@"RaioCell"];
    
    if (distance > 100 && localizacaoHabilitado)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"Situação:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Situacao"];
                break;
            case 1:
                cell.textLabel.text = @"AVCB Nº:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Numero"];
                break;
            case 2:
                cell.textLabel.text = @"Data da Vigência:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Validade"];
                break;
            case 3:
                cell.textLabel.text = @"Razão Social:";
                cell.detailTextLabel.text = [autoData objectForKey:@"RazaoSocial"];
                break;
            case 4:
                cell.textLabel.text = @"Endereço:";
                cell.detailTextLabel.text = [autoData objectForKey:@"DadosLogradouro"];
                break;
            case 5:
                cell.textLabel.text = @"Observações:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Observacoes"];
                break;
            case 6:
                raioCell.textLabel.numberOfLines = 3;
                raioCell.textLabel.text = @"\"A sua localização encontra-se a mais de 100 m do endereço indicado\"!";
                break;
                
            default:
                break;
        }
        if (indexPath.row != 6)
        {
            return cell;
        }
        else
        {
            return raioCell
            ;
        }
    }
    else if (distance <= 100 && localizacaoHabilitado) {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"Situação:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Situacao"];
                break;
            case 1:
                cell.textLabel.text = @"AVCB Nº:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Numero"];
                break;
            case 2:
                cell.textLabel.text = @"Data da Vigência:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Validade"];
                break;
            case 3:
                cell.textLabel.text = @"Razão Social:";
                cell.detailTextLabel.text = [autoData objectForKey:@"RazaoSocial"];
                break;
            case 4:
                cell.textLabel.text = @"Endereço:";
                cell.detailTextLabel.text = [autoData objectForKey:@"DadosLogradouro"];
                break;
            case 5:
                cell.textLabel.text = @"Observações:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Observacoes"];
                break;
            case 6:
                raioCell.textLabel.numberOfLines = 3;
                raioCell.textLabel.text = @"\"A sua localização encontra-se a menos de 100 metros do endereço acima indicado\"!";
                break;
                
            default:
                break;
        }
        if (indexPath.row != 6)
        {
            return cell;
        }
        else
        {
            return raioCell
            ;
        }
        
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"Situação:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Situacao"];
                break;
            case 1:
                cell.textLabel.text = @"AVCB Nº:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Numero"];
                break;
            case 2:
                cell.textLabel.text = @"Data da Vigência:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Validade"];
                break;
            case 3:
                cell.textLabel.text = @"Razão Social:";
                cell.detailTextLabel.text = [autoData objectForKey:@"RazaoSocial"];
                break;
            case 4:
                cell.textLabel.text = @"Endereço:";
                cell.detailTextLabel.text = [autoData objectForKey:@"DadosLogradouro"];
                break;
            case 5:
                cell.textLabel.text = @"Observações:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Observacoes"];
                break;
                
            default:
                break;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5) {
        NSString *texto = @"";
        
        switch (indexPath.row)
        {
            case 0:
                texto = [autoData objectForKey:@"Situacao"];
                break;
            case 1:
                texto = [autoData objectForKey:@"Numero"];
                break;
            case 2:
                texto = [autoData objectForKey:@"Validade"];
                break;
            case 3:
                texto = [autoData objectForKey:@"RazaoSocial"];
                break;
            case 4:
                texto = [autoData objectForKey:@"DadosLogradouro"];
                break;
            case 5:
                texto = [autoData objectForKey:@"Observacoes"];
                break;
                
            default:
                break;
        }
        
        UIFont *cellFont = [UIFont systemFontOfSize:14.0];
        CGSize size = [texto sizeWithFont:cellFont constrainedToSize:CGSizeMake(190, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        return (size.height + 5);
    }
    return 44.0;
}

@end
